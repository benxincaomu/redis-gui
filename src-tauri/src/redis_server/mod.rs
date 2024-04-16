#[macro_use]

/// 缓存不同的redis服务器
use std::{
    collections::{HashMap},
    sync::{
        Mutex, Arc,
        atomic::{AtomicUsize, Ordering},
    },
};

use crate::db;
use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};

/// 缓存不同的redis服务器连接
static CACHE: Lazy<Mutex<HashMap<String, redis::Client>>> = Lazy::new(|| {
    let m = HashMap::new();
    Mutex::new(m)
});

static ID: AtomicUsize = AtomicUsize::new(0);

// #[allow(missing_fields)]
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ServerInfo {
    id: Option<u32>,
    name: Option<String>,
    host: Option<String>,
    port: Option<u16>,
    auth: Option<String>,
}

crud!(ServerInfo {}, "server_info");
impl_select!(ServerInfo {select_by_name(name: String)->Option =>"`where name = #{name}`"});

/**
 * 保存服务器信息
 * @param info 服务器信息
 */
#[tauri::command]
pub async fn save_server_info(info: ServerInfo) -> String {
    let mut tx = db::get_tx_executor().await;
    let exist = ServerInfo::select_by_name(&tx, info.name.clone().unwrap())
        .await
        .unwrap();
    match exist {
        Some(_) => {
            tx.commit().await.unwrap();
            String::from("exist server name")
        }
        None => {
            let _ = ServerInfo::insert(&tx, &info).await.unwrap();
            let _ = tx.commit().await.unwrap();
            String::from("")
        }
    }
}

#[tauri::command]
pub async fn check_server_name(name: String) -> bool {
    let mut tx = db::get_tx_executor().await;
    let data = ServerInfo::select_by_name(&tx, name).await.unwrap();
    tx.commit().await.unwrap();
    match data {
        Some(_) => true,
        None => false,
    }
}

/**
 * 获取服务器信息,查看redis服务器列表时调用
 * @return 服务器信息列表
 */
#[tauri::command]
pub async fn load_server_infos() -> Vec<ServerInfo> {
    let mut tx = db::get_tx_executor().await;
    let data = ServerInfo::select_all(&tx).await.unwrap();
    tx.commit().await.unwrap();
    data
}

impl_select!(ServerInfo {select_by_id(id: u32)->Option =>"`where id = #{id}`"});
/**
 * 加载指定redis服务器信息，查看连接时使用
 * @param id 服务器信息id
 * @return 服务器信息
 */
#[tauri::command]
pub async fn load_server_info_by_id(id: u32) -> Option<ServerInfo> {
    let mut tx = db::get_tx_executor().await;
    let server_info = ServerInfo::select_by_id(&tx, id).await.unwrap();
    tx.commit().await.unwrap();
    server_info
}

/**
 * 创建redis连接，打开tab页时调用，返回缓存redis连接池的key
 * @param id redis服务器信息id
 * @return 连接池key
 */
#[tauri::command]
pub async fn create_connection(id: u32) -> String {
    let server_info = load_server_info_by_id(id).await.expect("");
    let mut cache = CACHE.lock().unwrap();
    let server_url = format!(
        "redis://{}:{}",
        server_info.host.unwrap(),
        server_info.port.unwrap()
    );
    let client = redis::Client::open(server_url);
    match client {
        Ok(cl) => {
            let query = redis::cmd("ping").query::<String>(&mut cl.get_connection().unwrap());
            match query {
                Ok(_data) => {
                    let cache_id = format!(
                        "{}:{}:{}",
                        server_info.name.unwrap(),
                        server_info.id.unwrap(),
                        ID.fetch_add(1, Ordering::Release)
                    );
                    cache.insert(cache_id.to_string(), cl);
                    cache_id
                }
                Err(_e) => "".to_string(),
            }
        }
        Err(e) => {
            println!("{:?}", e);
            "".to_string()
        }
    }
}

/**
 * 关闭redis连接，关闭tab页时调用
 * @param id 连接池key
 */
#[tauri::command]
pub fn close_connection(key: &str) {
    let mut cache = CACHE.lock().unwrap();
    if cache.contains_key(key) {
        cache.remove(key);
    }
}

/**
 * 执行redis命令，执行命令时调用
 */
#[tauri::command]
pub fn exe_command(key: String, command: String) -> String {
    let mut cache = CACHE.lock().unwrap();
    let client = cache.get_mut(&key);
    match client {
        Some(cl) => {
            let mut connection = cl.get_connection().unwrap();

            let split: Vec<&str> = command.split(" ").collect();
            let mut cmd_iter = split.iter();
            let mut cmd = "";
            let mut args: Vec<&str> = Vec::new();
            while let Some(c) = cmd_iter.next() {
                if c.len() == 0 {
                    continue;
                } else if cmd == "" {
                    cmd = c;
                } else {
                    args.push(c);
                }
            }
            // let query0 = redis::cmd("incr").arg(vec!["cc","1"]).query::<i32>(&mut connection);
            // let query :Result<i32, redis::RedisError>;
            let c = cmd.to_lowercase();
            match c.as_str() {
                "incr" | "decr" | "incrby" | "decrby" | "hincrby" | "hdecrby" => {
                    let query = redis::cmd(&c).arg(args).query::<i32>(&mut connection);
                    match query {
                        Ok(data) => data.to_string(),
                        Err(e) => {
                            println!("{:?}", e);
                            e.to_string()
                        }
                    }
                }

                _ => {
                    let query: Result<Option<String>, redis::RedisError> =
                        redis::cmd(cmd).arg(args).query(&mut connection);

                    match query {
                        Ok(data) => match data {
                            Some(data) => format!("\"{}\"", data),
                            None => "nil".to_string(),
                        },
                        Err(e) => {
                            println!("{:?}", e);

                            e.to_string()
                        }
                    }
                }
            }
        }
        None => {
            println!("{:?}", "redis连接不存在");

            "".to_string()
        }
    }
}

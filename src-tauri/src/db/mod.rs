
use lazy_static::lazy_static;
use rbatis::{executor::RBatisTxExecutor, RBatis};
use rbdc_sqlite::driver::SqliteDriver;

lazy_static! {
    static ref RB: RBatis = RBatis::new();
}

pub async fn init_rbatis() {
    // 获取工作目录的路径
    let work_dir = std::env::current_dir().unwrap();
    let work_dir = work_dir.to_str().unwrap();
    let _ = &RB
        .init(
            SqliteDriver {},
            format!("sqlite://{}/sqlite.db", work_dir).as_str(),
        )
        .unwrap();
    
}

/**
 * 获取执行器，事务使用
 */
pub async fn get_tx_executor() -> RBatisTxExecutor {
    RB.acquire_begin().await.unwrap()
}

pub async fn create_tables() {
    let _ = &RB.exec("create table if not exists server_info (id integer primary key AUTOINCREMENT, name text, 
host text,port integer,auth text)", [].to_vec()).await;
}

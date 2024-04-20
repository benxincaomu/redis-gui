// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
#[macro_use]
extern crate rbatis;

pub mod db;

pub mod redis_server;

use redis_server::*;
#[tokio::main]
async fn main() {
    // 初始化sqlite
    let _ = db::init_rbatis().await;
    let _ = db::create_tables().await;

    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            load_server_infos,
            save_server_info,
            load_server_info_by_id,
            create_connection,
            close_connection,
            exe_command
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

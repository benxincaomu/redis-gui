"use client"
import PropTypes from 'prop-types';
import { Button, Modal, List, message } from 'antd';
import Item from 'antd/es/list/Item';
import React, { useEffect, useState } from 'react';
import AddServerInfo from './addServerInfo';
import { invoke } from '@tauri-apps/api';

import { emit, listen } from '@tauri-apps/api/event';
export default function ServerList({ addTab }) {


    const [items, setItems] = useState([]);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const handleClick = (index) => {
        addTab({ index })
    }
    useEffect(() => {
        loadServerInfos();
    }, [])

    //读取服务器信息列表
    const loadServerInfos = () => {
        invoke("load_server_infos", []).then((res) => {
            setItems(res)
        })
    }

    const showModal = () => {
        setIsModalOpen(true)
    }
    const handleOk = () => {
        setIsModalOpen(false)
    }
    const handleCancel = () => {
        setIsModalOpen(false)
    }

    const closeModal = () => {
        setIsModalOpen(false)
    }
    const refresh = () => {
        loadServerInfos();
        setIsModalOpen(false);
    }
    const [messageApi, contextHolder] = message.useMessage();
    const handleClickServer = (serverId) => {
        console.log("addTab:", serverId);
        invoke("create_connection", { id: serverId }).then(async (res) => {
            if (!res) {
                messageApi.warning("连接失败");
            } else {
                // await emit("new_connection_id", res);
                addTab({ connId: res });
            }
        });
    }

    return (
        <>
            <List header={"服务器列表"} dataSource={items} bordered split={true} renderItem={(item) => (
                <Item onClick={() => handleClickServer(item.id)}>{item.name}</Item>
            )} />
            <Button onClick={() => showModal()}>新建连接</Button>
            <Modal title="弹窗" open={isModalOpen} onCancel={handleCancel} onOk={handleOk} footer={null}>
                <AddServerInfo closeModal={closeModal} refresh={refresh} />
            </Modal>
        </>
    );
};

ServerList.propTypes = {
    addTab: PropTypes.func.isRequired
}

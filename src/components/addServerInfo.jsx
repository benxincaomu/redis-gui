import { Button, Form, Input, Space, message } from 'antd';
import FormItem from 'antd/es/form/FormItem';
import React from 'react';
import PropTypes from 'prop-types';
import { invoke } from '@tauri-apps/api';

export default function AddServerInfo({ closeModal, refresh }) {

    const [messageApi, contextHolder] = message.useMessage();
    const saveInfo = (values) => {
        let info = { ...values };
        info.port = parseInt(info.port);

        invoke('save_server_info', { info: { ...info } }).then((res) => {
            if (res) {
                messageApi.warning(res)
            } else {

                refresh();
            }
        })
    }

    const onFinishFailed = (errorInfo) => {
    }
    const validatePort = (_, value) => {
        if (isNaN(value) || !(value == Math.floor(value))) {
            return Promise.reject('端口号必须是整数');
        } else if (value < 0 || value > 65535) {
            return Promise.reject('端口范围0-65535');
        } else {
            return Promise.resolve();
        }
    }

    const layout = {
        labelCol: {
            span: 8,
        },
        wrapperCol: {
            span: 16,
        },
    };
    const tailLayout = {
        wrapperCol: {
            offset: 8,
            span: 16,
        },
    };



    return (<>
        <Form name="form1" onFinish={saveInfo} onFinishFailed={onFinishFailed} {...layout}>
            <FormItem label="连接名称" name="name" rules={[{ required: true, message: '请输入连接名称!' }]}>
                <Input placeholder="请输入连接名称" />
            </FormItem>
            <FormItem label="连接地址" name="host" rules={[{ required: true, message: '请输入连接地址!' }]}>
                <Input placeholder="连接地址" />
            </FormItem>
            <FormItem label="连接端口" name="port" rules={[{ required: true, message: '请输入连接端口!' }, { validator: validatePort }]}>
                <Input placeholder="连接端口" />
            </FormItem>
            <FormItem label="连接用户" name="auth">
                <Input placeholder="连接用户" />
            </FormItem>
            <FormItem {...tailLayout}>
                <Space>
                    <Button type='primary' htmlType="submit">保存</Button>
                    <Button onClick={() => closeModal()}>取消</Button>
                </Space>
            </FormItem>
        </Form>
        {contextHolder}
    </>);
}

AddServerInfo.propTypes = {
    closeModal: PropTypes.func.isRequired,
    refresh: PropTypes.func.isRequired
}

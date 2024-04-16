"use client"

import React, { useState, useCallback, useEffect } from 'react';
import { Tabs } from 'antd';
import PropTypes from 'prop-types';
// import RedisPanel from './RedisPanel';
export default function MainPanel({ panes, deleteTab }) {


    const [activeKey, setActiveKey] = useState("");
    const [items, setItems] = useState([]);

    useEffect(() => {
        setItems(panes);
        if(panes.length>0){

            setActiveKey(panes[panes.length - 1].key);
        }
        console.log("panes", panes);
    }, [panes]);
    const handleEdit = (targetKey, action) => {
        if (action === 'add') {
        } else {
            deleteTab({connId: targetKey});
        }
    }

    return (
        <>
            <Tabs type="editable-card" hideAdd activeKey={activeKey} onTabClick={(key, event) => {
                setActiveKey(key);
            }} items={items} onEdit={handleEdit} style={{ maxHeight: "100%", height: "100%" }} />

        </>

    );
}
MainPanel.propTypes = {
    panes: PropTypes.array.isRequired,
    deleteTab: PropTypes.func.isRequired,
}

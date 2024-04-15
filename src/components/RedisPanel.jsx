import { invoke } from '@tauri-apps/api';
import { Input } from 'antd';
import PropTypes from 'prop-types';
import React, { useRef, useEffect, useState } from 'react';

export default function RedisPanel({ connId }) {
    const [inputValue, setInputValue] = useState('');
    const [texts, setTexts] = useState([]);
    /* useEffect(() => {
        console.log('RedisPanel:', connId);
    }, [connId]); */

    // 实时获取窗口大小
    const [windowSize, setWindowSize] = useState({ width: window.innerWidth, height: window.innerHeight });
    useEffect(() => {
        const handleResize = () => {
            setWindowSize({ width: window.innerWidth, height: window.innerHeight });
        };
        window.addEventListener('resize', handleResize);
        return () => {
            window.removeEventListener('resize', handleResize);
        };
    }, []);

    const calculateHeight = (windowHeight) => {
        return windowHeight - 215;
    };

    const showResRef = useRef();

    return (
        <div>
            <div style={{ height: calculateHeight(windowSize.height), overflowY: 'auto' }} ref={showResRef}>{texts}</div>
            <div style={{ width: '90%', height: '10%', minHeight: '50px' }}>
                <Input value={inputValue} autoFocus onChange={(e) => setInputValue(e.target.value)} style={{ width: '100%', height: '100%' }} onPressEnter={(e) => {
                    texts.pop();
                    let br = React.createElement("div", '', e.target.value);
                    texts.push(br);
                    setTexts([...texts]);
                    setInputValue("");
                    invoke('exe_command', { key: connId, command: e.target.value }).then(res => {
                        br = React.createElement("div", '', res);
                        texts.push(br);
                        texts.push(React.createElement("div", '', ""));
                        setTexts([...texts]);
                        showResRef.current.scrollTop = showResRef.current.scrollHeight+10;
                    });
                }} />
            </div>
        </div>
    )
}

RedisPanel.propTypes = {
    connId: PropTypes.string.isRequired
}
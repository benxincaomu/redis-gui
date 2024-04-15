"use client"
import React, { useState } from "react";
import { Layout } from "antd";
import ServerList from "./serverList";
import MainPanel from "./mainPanel";
import PropTypes from 'prop-types';
import RedisPanel from "./RedisPanel";


const { Header, Content, Footer, Sider } = Layout;
const colorBgContainer = "#fff";
export default function Home() {

  const [panes, setPanes] = useState([]);
  const addTab = ({ connId }) => {
    addTab.propTypes = {
      connId: PropTypes.string.isRequired,
    }
    console.log("addTab:", connId);
    let newPanes = [...panes];
    newPanes.push({
      key: connId,
      label: connId,
      children: <RedisPanel connId={connId} />,
    });
    setPanes(newPanes);
  }
  const deleteTab = ({connId}) => {
    deleteTab.propTypes = {
      connId: PropTypes.string.isRequired,
    }
    let newPanes = panes.filter(pane => pane.key !== connId);
    setPanes(newPanes);
  }

  return (
    <>
      <Layout style={{ height: '100%' }}>
        <Header style={{
          display: 'flex',
          alignItems: 'center',
          backgroundColor: '#f3f2f2',
        }}>
          <div>Header</div>
        </Header>
        <Layout>
          <Sider width={200}
            style={{
              background: colorBgContainer,
            }}>
            <ServerList addTab={addTab} />
          </Sider>
          <Content style={{ backgroundColor: '#cfc9cb', height: '100%' }}> <MainPanel panes={panes} deleteTab={deleteTab} /> </Content>
        </Layout>
        <Footer>Footer</Footer>
      </Layout>

    </>
  );
}

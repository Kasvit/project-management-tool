import React from "react";
import PropTypes from "prop-types";
import _ from "lodash";
import { WidthProvider, Responsive } from "react-grid-layout";
import TopUsersCard from '../TopUsersCard'
import TopWorkspacesCard from '../TopWorkspacesCard';
import TasksInfoCard from '../TasksInfoCard'
import UserInfoCard  from '../UserInfoCard'
import CommentsInfoCard  from '../CommentsInfoCard';

import * as api from '../../Api/layout_api';
import * as config from '../config.js';

import "./dashboard.scss";
import "react-grid-layout/css/styles.css";
import "react-resizable/css/styles.css";

const ResponsiveReactGridLayout = WidthProvider(Responsive);

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    const defaults = [
      {i: 'tasks-info-card', x: 0, y: 0, w: 7, h: 9},
      {i: 'top-users-card', x: 1, y: 0, w: 7, h: 9},
      {i: 'user-info-card', x: 2, y: 0, w: 7, h: 9},
      {i: 'comments-info-card', x: 3, y: 0, w: 7, h: 9},
      {i: 'top-workspaces-card', x: 5, y: 0, w: 6, h: 8}
    ];

    this.state = {
      layout: this.props.layout != null ? this.props.layout : defaults
    }

    this.onDragStop = this.onDragStop.bind(this);
    this.onResizeStop = this.onResizeStop.bind(this);
  }

  componentDidMount() {
    api.load_layout().then(data => {
      if(data != null) {
        this.setState({ layout: data.layout})
      }
    });
  }

  onDragStop(layout) {
    api.save_layout(layout);
  }

  onResizeStop(layout) {
    api.save_layout(layout);
  }

  render() {
    return (
      <ResponsiveReactGridLayout
        className="layout"
        breakpoints={{lg: 1200}}
        cols={{lg: 12}}
        rowHeight={30}
        width={1200}
        onDragStop={(layout) => this.onDragStop(layout)}
        onResizeStop={(layout) => this.onResizeStop(layout)}
        layouts={{lg: this.state.layout}}
        useCSSTransforms={false}
      >
        <div className="box" key="tasks-info-card" data-grid={{i: 'tasks-info-card', x: 0, y: 0, w: 4, h: 8, minW: 8, minH: 12}}>
          <TasksInfoCard/>
        </div>
        <div className="box" key="top-users-card" data-grid={{i: 'top-users-card', x: 0, y: 2, w: 7, h: 9, minW: 8, minH: 12}}>
         <TopUsersCard/>
       </div>
        <div className="box" key="user-info-card" data-grid={{i: 'user-info-card', x: 0, y: 0, w: 7, h: 9, minW: 7, minH: 9}}>
          <UserInfoCard/>
        </div>
        <div className="box" key="comments-info-card" data-grid={{i: 'comments-info-card',  x: 0, y: 0, w: 5, h: 9, minW: 7, minH: 9}}>
          <CommentsInfoCard/>
        </div>
        <div className="box" key="top-workspaces-card" data-grid={{i: 'top-workspaces-card', x: 4, y: 8, w: 6, h: 8, minW: 6, minH: 8}}>
          <TopWorkspacesCard/>
        </div>
      </ResponsiveReactGridLayout>
    )
  }
}

export default Dashboard;

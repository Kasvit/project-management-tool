import React from "react";
import PropTypes from "prop-types";
import _ from "lodash";
import { WidthProvider, Responsive } from "react-grid-layout";
import * as config from '../config.js';

import "./dashboard.scss";
import "react-grid-layout/css/styles.css";
import "react-resizable/css/styles.css";

const ResponsiveReactGridLayout = WidthProvider(Responsive);

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      layout: [],
      response: ""
    }

    this.onDragStop = this.onDragStop.bind(this);
  }

  componentDidMount() {
    fetch(`${config.DEFAULT_URL}/api/dashboard/load`)
      .then(response => response.json())
      .then(parsedJSON => this.setState(parsedJSON))
      .catch(error => console.error('Error:', error));
  }

  onDragStop(layout) {
    this.setState({ layout: layout });

    fetch(`${config.DEFAULT_URL}/api/dashboard/save`, {
        method: 'PUT',
        body: JSON.stringify({layout: this.state.layout}),
        headers: {
          'Content-Type': 'application/json'
        }
      }
    ).catch(error => console.error('Error:', error));
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
        layouts={{lg: this.state.layout}}
      >
        <div className="box layout-js" key="a" data-grid={{i: 'a', x: 0, y: 0, w: 1, h: 2}}>a</div>
        <div className="box layout-js" key="b" data-grid={{i: 'b', x: 1, y: 0, w: 1, h: 2}}>b</div>
        <div className="box layout-js" key="c" data-grid={{i: 'c', x: 2, y: 0, w: 1, h: 2}}>c</div>
        <div className="box layout-js" key="d" data-grid={{i: 'd', x: 3, y: 0, w: 1, h: 2}}>d</div>
        <div className="box layout-js" key="e" data-grid={{i: 'e', x: 4, y: 0, w: 1, h: 2}}>e</div>
      </ResponsiveReactGridLayout>
    )
  }
}

export default Dashboard;

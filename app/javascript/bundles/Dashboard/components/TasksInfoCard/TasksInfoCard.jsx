import React from "react";
import PropTypes from "prop-types";
import _ from "lodash";
import { ComposedChart, Line, Area, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import "./tasks-info-card.scss";

class TasksInfoCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: null,
      workspaces: null,
      active: 'All Workspaces',
      isLoading: true,
      collection: null
    };
  }

  componentDidMount() {
    this.setState({ isLoading: true });
    fetch('http://localhost:3000/account/tasks-info')
      .then(response => response.json())
      .then(data => this.setState({ data: data.info, workspaces: data.workspaces, collection: data.collection, isLoading: false }));
  }

  handleClick(id){
    let workspaceUrl='';
    if (id != 'all'){
      workspaceUrl=`?id=${encodeURIComponent(id)}`;
    }
    this.setState({ isLoading: true });
    fetch(`http://localhost:3000/account/tasks-info${workspaceUrl}`)
      .then(response => response.json())
      .then(data => this.setState({ data: data.info, active: this.state.workspaces[id] || 'All Workspaces', isLoading: false }))
  }

  render() {
    if (this.state.isLoading) {
      return <p>Loading ...</p>;
    }

    return (
      <div>
        <SelectWorkspace workspaces={this.state.workspaces} active={this.state.active} onClick={(id) => this.handleClick(id)}/>
        <SameDataComposedChart data={this.state.data} width={this.props.width}/>
      </div>
    )
  }
}

class SameDataComposedChart extends React.Component {
	render () {
    const width = this.props.width;
    console.log(width);
  	return (
      <ComposedChart width={width} height={2*width/3} data={this.props.data} >
        <CartesianGrid stroke='#777'/>
        <XAxis dataKey="name" fontSize='0.7rem'/>
        <YAxis fontSize='0.7rem'/>
        <Tooltip/>
        <Legend width={width} wrapperStyle={{fontSize: '0.7rem', left: '0'}}/>
        <Bar dataKey='uncompleted' barSize={width/30} fill='#413ea0'/>
        <Line type='monotone' dataKey='due soon' stroke='#ff7300'/>
        <Line type='monotone' dataKey='outdated' stroke='#ff4306'/>
      </ComposedChart>
    );
  }
}

class SelectWorkspace extends React.Component {

	render () {
    const workspaces = this.props.workspaces;
  	return (
      <div className="dropdown is-hoverable">
        <div className="dropdown-trigger">
          <button className="button" aria-haspopup="true" aria-controls="dropdown-menu">
            <span>{this.props.active}</span>
            <span className="icon is-small">
              <i className="fas fa-angle-down" aria-hidden="true"></i>
            </span>
          </button>
        </div>
        <div className="dropdown-menu" id="dropdown-menu" role="menu">
          <div className="dropdown-content">
            <li className="dropdown-item" key='all' onClick={() => this.props.onClick('all')}>All Workspaces</li>
            { Object.entries(workspaces).map(([key, value]) => {
              return <li href="#" className="dropdown-item" key={key} onClick={() => this.props.onClick(key)}>
                        {value}
                      </li>
            })}
          </div>
        </div>
      </div>
    );
  }
}

export default TasksInfoCard;

import * as types from './mutation-types'

const mutations = {
    [types.SET_TASKLIST](state,taskList){
        state.taskList=taskList;
    },
    [types.SET_CURRENTASK](state,currentTask){
        state.currentTask=currentTask;
    },
    [types.SET_CALLBACKLIST](state,callbackList){
        state.callbackList=callbackList;
    },
    [types.SET_CURRENTCALLBACK](state,currentCallback){
        state.currentCallback=currentCallback;
    },
    [types.SET_REPORTUID](state,reportUid){
        state.reportUid=reportUid;
    },
};
export  default mutations;
import * as types from './mutation-types'

export const setTaskList = function ({commit}, task) {
    commit(types.SET_TASKLIST, task)
};
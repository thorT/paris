import storage from 'good-storage'

const UID_KEY = '__uid__';
const NOWTASK_KEY = '__nowtask__';
const ACTIVETIME_KEY = '__active__';

const NOWCALLTASK = '__nowcallback__';
const CALLBACKACTIVETIME_KEY = '__callactive__';


export  function setUid(uid){
  storage.set(UID_KEY, uid)
  return uid;
}
export function getUid(){
  return storage.get(UID_KEY,'')
}
export function clearUid() {
  storage.remove(UID_KEY);
  return []
}
export  function setNowTask(taskObj){
  storage.set(NOWTASK_KEY, taskObj);
  return taskObj;
}
export function getNowTask(){
  return storage.get(NOWTASK_KEY, {})
}
export function clearNowTask() {
  storage.remove(NOWTASK_KEY);
  return []
}
export  function setActiveTime(time){
  storage.set(ACTIVETIME_KEY, time);
  return time;
}
export function getActiveTime(){
  return storage.get(ACTIVETIME_KEY, 0)
}
export function clearActiveTime() {
  storage.remove(ACTIVETIME_KEY);
  return []
}

export  function setNowCallback(taskObj){
  storage.set(NOWCALLTASK, taskObj);
  return taskObj;
}
export function getNowCallback(){
  return storage.get(NOWCALLTASK, {})
}
export function clearNowCallback() {
  storage.remove(NOWCALLTASK);
  return []
}
export  function setCallbackActiveTime(time){
  storage.set(CALLBACKACTIVETIME_KEY, time);
  return time;
}
export function getCallbackActiveTime(){
  return storage.get(CALLBACKACTIVETIME_KEY, 0)
}
export function clearcallbackActiveTime() {
  storage.remove(CALLBACKACTIVETIME_KEY);
  return []
}
import mloadval from './mload.vue';

// 定义插件对象
const Loading = {};
// vue的install方法，用于定义vue插件
Loading.install = function (Vue, options) {
    const LoadInstance = Vue.extend(mloadval);
    let currentLoad;
    const initInstance = () => {
        // 实例化vue实例
        currentLoad = new LoadInstance();
        let loadEl = currentLoad.$mount().$el;
        document.body.appendChild(loadEl);
    };
    // 在Vue的原型上添加实例方法，以全局调用
    Vue.prototype.$loading = {
        show (options) {
            if(!currentLoad){
                initInstance();
            }
            if (typeof options === 'string') {
                currentLoad.content = options;
            } else if (typeof options === 'object') {
                Object.assign(currentLoad, options);
            }
            return currentLoad.show()

        },
        close(){
                if(currentLoad){
                    return currentLoad.close()
                }
        },
        remove(){
            if(currentLoad){
                currentLoad.destroy()
                currentLoad=null;
            }
        }
    };
};

export default Loading;

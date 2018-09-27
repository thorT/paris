// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import fastclick from 'fastclick'
import 'babel-polyfill'
import Vue from 'vue'
import App from './App'
import router from './router'
import 'common/stylus/index.styl'
import lazyload from 'vue-lazyload'
import Navigation from 'vue-navigation'
import Loading from  "@/components/overall/mload"
Vue.use(Loading);


Vue.config.productionTip = false; //阻止 vue 在启动时生成生产提示
//解决300毫秒延迟
fastclick.attach(document.body);
Vue.use(lazyload,{
  loading:require('static/image/user3.png')
});
Vue.use(Navigation, {router});

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})

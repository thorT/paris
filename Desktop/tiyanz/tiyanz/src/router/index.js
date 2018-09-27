import Vue from 'vue'
import Router from 'vue-router'
const Index = resolve => require(['@/components/index/index'], resolve);
// user
const User = resolve => require(['@/components/user/user'], resolve);
const Invite = resolve => require(['@/components/user/invite'], resolve);
const About = resolve => require(['@/components/user/about'], resolve);
const Getcrashrecord = resolve => require(['@/components/user/getcrashrecord'], resolve);
const Inviterecord = resolve => require(['@/components/user/inviterecord'], resolve);
const Myincome = resolve => require(['@/components/user/myincome'], resolve);
const Cooperation = resolve => require(['@/components/user/cooperation'], resolve);
const Questions = resolve => require(['@/components/user/questions'], resolve);
// settting
const Setting = resolve => require(['@/components/setting/setting'], resolve);
const Verifyphone = resolve => require(['@/components/setting/verifyphone'], resolve);
const Bindalipay = resolve => require(['@/components/setting/bindalipay'], resolve);
// getcrash
const Getcrash = resolve => require(['@/components/getcrash/getcrash'], resolve);
const Apply = resolve => require(['@/components/getcrash/apply'], resolve);
// task
const Tasklist = resolve => require(['@/components/tasklist/tasklist'], resolve);
const Tctasklist = resolve => require(['@/components/tasklist/tctasklist'], resolve);
const Taskdetail = resolve => require(['@/components/tasklist/taskdetail'], resolve);
const Wpdetail = resolve => require(['@/components/tasklist/wptask/wpdetail'], resolve);

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: Index
    },
    {
      path: '/getcrash',
      name: 'getcrash',
      component: Getcrash
    },
    {
      path: '/apply',
      name: 'apply',
      component: Apply
    },
    {
      path: '/user',
      name: 'user',
      component: User,
      meta: {
        uid: ''
      }
    },
    {
      path: '/invite',
      name: 'invite',
      component: Invite
    },
    {
      path: '/about',
      name: 'about',
      component: About
    },
    {
      path: '/questions',
      name: 'questions',
      component: Questions
    }
    ,
    {
      path: '/getcrashrecord',
      name: 'getcrashrecord',
      component: Getcrashrecord
    }
    ,
    {
      path: '/inviterecord',
      name: 'inviterecord',
      component: Inviterecord
    }
    ,
    {
      path: '/myincome',
      name: 'myincome',
      component: Myincome
    }
    ,
    {
      path: '/cooperation',
      name: 'cooperation',
      component: Cooperation
    }
    ,
    {
      path: '/setting',
      name: 'setting',
      component: Setting
    }
    ,
    {
      path: '/verifyphone',
      name: 'verifyphone',
      component: Verifyphone
    }
    ,
    {
      path: '/bindalipay',
      name: 'bindalipay',
      component: Bindalipay
    },
    {
      path: '/tasklist',
      name: 'tasklist',
      component: Tasklist
    }
    ,
    {
      path: '/taskdetail',
      name: 'taskdetail',
      component: Taskdetail
    }
    ,
    {
      path: '/tctasklist',
      name: 'tctasklist',
      component: Tctasklist
    }
    ,
    {
      path: '/wpdetail',
      name: 'wpdetail',
      component: Wpdetail
    }
  ]
})

<template>
  <div id="tasklist" class="navi">
    <MHeader :title="'联盟任务'" :shadow="true"></MHeader>
    <Loading v-if="initRequst==true"></Loading>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" :data="info">
        <ul class="list X_paddingbottom">
          <li v-for="item, index in info" @click="goto(item)">
            <img class="list_icon" :src="item.app_icon" alt="">
            <div class="list_des">
              <h2>{{item.app_name}}</h2>
              <h4>剩余{{item.limit}}份</h4>
            </div>
            <i>+{{item.bill}}</i>
            <img  class="ignore" src="../../assets/image/ignore.png" @click.stop="ignoreAction(item)">
            <h5 v-if="index!==0"></h5>
          </li>
        </ul>
      </Scroll>
    </div>
    <note v-if="!initRequst&&info.length<=0" :title="'你很勤快，今天的任务你已经做完了'" ></note>
    <Msg :text="msgtitle" ref="msg"></Msg>
    <dialogS :showDialog="dialogShow" :msg="'确定要屏蔽这个任务吗?<br>这个任务将不会出现在你的列表里'" :sure="'屏蔽'" @sureAction="sureAction" @cancelAction="cancelAction"></dialogS>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Scroll from '@/components/public/scroll'
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'
  import Loading from '@/components/public/loading'
  import note from '@/components/public/note'
  import Msg from "@/components/public/msg";
  import dialogS from "@/components/public/dialogSingle";

  export default {
    data() {
      return {
        info: [],
        initRequst: true,
        msgtitle:'',
        contentH:0,
        dialogShow:false,
        seletedItem:{}
      }
    },
    components: {
      MHeader, Scroll,Loading,note,Msg,dialogS
    },
    methods: {
      pulldown() {
        this.initData();
      },
      goto(item){
       this.$router.push({path:'/wpdetail',query:{item:item}});
      },
      ignoreAction(item){
        this.selectedItem = item;
        this.dialogShow = true;
      },
      sureAction(item){
        this.dialogShow = false;
        this.$loading.show();
        let itunes_id = this.selectedItem.itunes_id;
        let channel = this.selectedItem.channel;
        appfc('js_netFull','_tasklistignore',{storeid:itunes_id,channel:channel},constant.api_ignore);
      },
      _tasklistignore(res){
        if (res.code == 200) {
          this.initData();
        } else {
          this.$loading.close();
          this.msgtitle = res.msg;
          this.$refs.msg.show()
        }
      },
      cancelAction(){
        this.dialogShow = false;
      },
      _taskList(res){
        this.initRequst = false;
        this.$loading.close();
        if (res.code == 200) {
          this.info = res.data;
        } else {
          this.msgtitle = res.msg;
          this.$refs.msg.show()
        }
        this.$nextTick(function () {
          this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
        });
      },
      initData(){
        appfc('js_netFull','_taskList',{},constant.api_wapsList);
      }
    },
    mounted() {
      this.initData();
      window._taskList = this._taskList;
      window._tasklistignore = this._tasklistignore;
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #tasklist
    width 100%
  .main
    font-weight normal
    position relative
    overflow scroll
    width 100%
    bottom 0px
    top 0px
    li
      width 100%
      height 160px
      overflow hidden
      img
        display inline-block
        float left
        width 88px
        height 88px
        margin-top 36px
        margin-left 30px
        border-radius 12px
      .list_des
        float left
        margin-left 20px
        padding-top 36px
        width 45%
        h2
          line-height 40px
          height 54px
          font-size $font-size-medium
        h4
          line-height 30px
          height 30px
          font-size $font-size-small
          color $color-text-gray
      i
        display inline-block
        float right
        margin-top 45px
        margin-right 30px
        line-height 60px
        width 110px
        height 60px
        text-align center
        color $color-theme
        border 1px solid $color-theme;
        border-radius 10px
      .ignore
        display inline-block
        float right
        margin-right 10px
        width 40px
        height 40px
      h5
        height 1px
        background $color-line-gray
        margin-left 30px
</style>

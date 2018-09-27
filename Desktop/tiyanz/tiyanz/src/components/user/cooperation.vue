<template>
  <div id="cooperation" class="navi">
    <MHeader :title="'商务合作'" :shadow="true"></MHeader>
    <img src="../../assets/image/qq.png" alt="">
    <h2>{{qq}}</h2>
    <h4>如需商务合作，请加以上QQ，请简单描述合作内容</h4>
    <div class="button" @click="pasteqq">
      <h3>复制QQ</h3>
    </div>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import {appfc} from '@/common/js/app'
  import Msg from "@/components/public/msg"
  export default {
    data () {
      return {
        qq:'',
        msgtitle:'',
      }
    },
    components:{
      MHeader,Msg
    },
    methods: {
      pasteqq(){
        appfc('js_setPasteboard','_cooperationQQ',{'str':this.qq},'')
      },
      _cooperationQQ(res){
        this.msgtitle = '商务QQ已复制';
        this.$refs.msg.show();
      },
    },
    mounted (){
      window._cooperationQQ= this._cooperationQQ;
      this.$nextTick(function () {
        this.qq = this.$route.query.qq;
      })
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #cooperation
    width 100%
    text-align center
    img
      width 100px
      height 100px
      margin-top 110px
      border-radius 50px
      box-shadow 1px 1px 2px #888
    h2
      margin-top 30px
      color $color-text
      font-size $font-size-large-x
    h4
      margin-top 310px
      color $color-text-gray
      font-size $font-size-small
    .button
      width 85%
      background $color-theme
      border-radius 42.5px
      margin 40px auto 0
      h3
        height 85px
        line-height 85px
        color white




</style>

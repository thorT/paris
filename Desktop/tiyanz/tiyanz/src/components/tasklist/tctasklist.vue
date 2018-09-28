<template>
  <div id="tctasklist" class="navi">
    <MHeader :title="'调查'" :shadow="true"></MHeader>
    <Loading v-if="initRequst==true"></Loading>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" :pullDownRefresh="{threshold: 50,stop: 35}" @pullingDown="pulldown" :data="info">
        <ul class="list X_paddingbottom">
          <li v-for="item, index in info" @click="goto(item)">
            <img v-if="index==0" class="list_icon" src="../../assets/image/tcdaily.png" alt="">
            <img v-else-if="index==1" class="list_icon" src="../../assets/image/tc/tcpeanut.png" alt="">
            <img v-else class="list_icon" src="../../assets/image/tc/tcdefault.png" alt="">
            <div class="list_des">
              <h2>{{item.Name}}</h2>
              <h4>{{item.limit?item.limit:'诚实对待调研'}}</h4>
            </div>
            <i>{{index<2?item.Money:'+'+item.Money}}</i>
            <h5 v-if="index!==0"></h5>
          </li>
        </ul>
      </Scroll>
    </div>
    <note v-if="!initRequst&&info.length<=0" :title="'目前还没有任何调查项目'" ></note>
    <Msg :text="msgtitle" ref="msg"></Msg>
    <tcdialog :showDialog="dialogShow" :msg="'请诚实对待商品调研，不然可以得不到奖励，或者被商家拉入黑名单；首次进入稍慢，大约需要2-3分钟，可以将手机放到一旁等待加载，奖励确实非常非常丰厚'"
    @sureAction="sureAction" @cancelAction="cancelAction" @usedAction="usedAction"></tcdialog>
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
  import tcdialog from '@/components/public/tcdialog'
  export default {
    data () {
      return {
        contentH: 0,
        firstCell:[
          {Name: '每日调查-天天更新',limit:"根据你的适配度获得报酬",Money:'不固定',
            LiveLink:'http://www.tctask.com/index.php?e=index.loading&coopid=1218&userid=[userid]&id=1303'},
          {Name: '花生实验室',limit:"诚实对待调研",Money:'不固定',
            LiveLink:'http://www.tctask.com/index.php?e=index.loading&coopid=1218&userid=xxx&id=39163'},
        ],
        info:[],
        initRequst: true,
        msgtitle:'',
        selectedItem:{},
        dialogShow:false
      }
    },
    components:{
      MHeader, Scroll,Loading,note,Msg,tcdialog
    },
    methods: {
      sureAction(){
        appfc('js_saveData', '_tcsaveData', {}, '');
      },
      _tcsaveData(res){
        var str =  this.selectedItem.LiveLink;
        var newstr = str.replace( '[userid]' , res.param.uid );//is_dk
        appfc('js_safari','', {'url':newstr,'is_dk':0,name:this.selectedItem.Name},'');
        this.dialogShow = false;
      },
      cancelAction(){
        this.dialogShow = false;
      },
      usedAction(){
        this.dialogShow = false;
        this.$loading.show();
        appfc('js_net','_tcused', {SurveyId:this.selectedItem.SurveyId},constant.api_taskDid);
      },
      _tcused(res){
        if (res.code == 200) {
          this.initData();
        } else {
          this.$loading.close();
          this._switchTip(res.msg);
        }
      },
      pulldown() {
        this.initData();
      },
      goto(item){
        this.selectedItem = item;
        this.dialogShow = true;
      },
      _tctask(res){
        this.initRequst = false;
        this.info=[];
        if (res.code == 200) {
        this.info = this.firstCell.concat(res.data);
        } else {
          this._switchTip(res.msg);
        }

        this.$nextTick(function () {
          this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
        });
        this.$loading.close();
      },
      initData(){
        appfc('js_net','_tctask',{},constant.api_getSurveyList);
      }
    },
    mounted() {
      window._tctask = this._tctask;
      window._tcused = this._tcused;
      window._tcsaveData=this._tcsaveData;
      this.initData();
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #tctasklist
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
      img
        display inline-block
        float left
        width 100px
        height 100px
        padding-top 20px
        padding-left 30px
      .list_des
        float left
        margin-left 20px
        padding-top 36px
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
      h5
        height 1px
        background $color-line-gray
        margin-left 30px
</style>

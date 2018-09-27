<template>
    <div class="apply bg navi">
      <Mheader :title="'申请提现'" :shadow="true"></Mheader>
      <div class="applycontain">
        <Scroll class="mscroll">
          <div>
            <ul class="bgt">
              <li class="bigli">
                <h3 class="fm topP">提现到</h3>
                <p class="fm">
                  <span> <i class="icon iconfont topP">&#xe6b7;</i>支付宝</span>
                </p>
              </li>
            </ul>
            <ul class="bgt">
              <li>
                <h3 class="fm">提现金额</h3>
                <p class="gray fm">
                  <span>{{choose}}</span>
                </p>
              </li>
            </ul>
            <section>
              <span v-for="item in cashOption" :class="item==currentOpt?'active':''" @click="changeOpt(item)">{{item}}元</span>
            </section>
            <ul class="bgt">
              <li>
                <h3 class="fm">可提现金额</h3>
                <p class="gray fm">
                  <span>{{price}}</span>
                </p>
              </li>
              <li>
                <h3 class="fm">预计到账时间</h3>
                <p class="gray fm">
                  <span>周末顺延，预计下周一到账</span>
                </p>
              </li>
            </ul>
            <p v-for="tip in tips" class="gray fs" v-html="tip">
            </p>
            <Mbutton :title="'提交'" class="mtop" @buttonAction="sumbit"></Mbutton>
            <div style="width: 100%;height: 10px;"></div>
            <Mbutton :title="'查看提现记录'" :bgColor="'white'" :titleColor="'#333333'" @buttonAction="goto('/getcrashrecord')"></Mbutton>

          </div>

        </Scroll>
        <Msg :text="msgtitle" ref="msg"></Msg>
      </div>

    </div>
</template>

<script type="text/ecmascript-6">
  import Mheader from "@/components/public/mheader";
  import Mbutton from "@/components/public/mbutton";
  import Scroll from '@/components/public/scroll'
  import norecord from "@/components/public/norecord";
  import {appfc} from '@/common/js/app'
  import Msg from "@/components/public/msg";

  export default {
    components: {
      Mheader, Mbutton, Scroll, norecord,Msg
    },
    data(){
      return {
        cashOption: [
          10, 20, 30, 50, 100, 200
        ],
        tipsShow: false,
        price: "0",
        choose: '请选择金额',
        currentOpt: 10,
        msgtitle:'',
        tips: [
          " <div style='line-height: 20px'>· <i class='blue'>支付宝</i>每笔提现均会扣除<i class='blue'>1元手续费</i></div>",
          " <div style='line-height: 20px'>· 到账时间最快当天，通常为第二天到账</div>",
          " <div style='line-height: 20px'>· <i class='blue'>周末、法定节假日不处理提现</i>(周5-6顺延周1,周7顺延周2)</div>",
          " <div style='line-height: 20px'>· 所以提现均人工审核，审核完成后由系统自动打款</div>",
          " <div style='line-height: 20px'>· 如支付宝账号错误,多设备多账号等作弊行为会导致提现失败</div>"
        ],
        options: [
          {name: '提现金额', content: '请输入金额', input: true},
          {name: '可提现金额', content: '500元', input: false},
          {name: '预计到账时间', content: '周末顺延，预计下周一到账', input: false},
        ],
        phone:'',
        alipay:'',
        is_udid:0
      }
    },
    methods: {
      goto(path){
        this.$router.push(path)
      },
      _applyed(res){
        if (res.code != 200) {
          this.msgtitle = res.msg;

        } else {
          this.msgtitle = "已提交，等待审核中";
          this.price = this.price - this.currentOpt;
        }
        this.$refs.msg.show();

      },
      sumbit(){
        if (this.price < this.currentOpt) {
          this.msgtitle = "余额不足";
          this.$refs.msg.show();
        }else if(this.phone.length<11){
          this._gotoVari('请绑定手机号','/verifyphone');
        }else if(this.alipay.length<11){
          this._gotoVari('请绑定支付宝','/bindalipay');
        }else if(this.is_udid!=1){
          this._gotoVari('请验证设备','/setting');
        }else{
          appfc('js_net','_applyed',{'price': this.currentOpt, 'type': "alipay"},'withdrawApply');
        }
      },
      _gotoVari(msg,path){
        this.msgtitle = msg;
        this.$refs.msg.show();
        let _self = this;
        let timer = window.setInterval(function () {
          _self.$router.push(path);
            window.clearInterval(timer);
        },1500);
      },
      changeOpt(item){
        this.currentOpt = item;
        this.choose = item + "元"

      },
      _applysavedata(res) {
        //bindphone
        if(res.param.phone) {
          this.phone = res.param.phone;
        }
        //bindalipay
        if(res.param.alipay) {
          this.alipay = res.param.alipay;
        }
        //bindphone
        if(res.param.is_udid) {
          this.is_udid = res.param.is_udid;
        }
        //price
        if(res.param.price) {
          this.price = res.param.price;
        }
      }
    },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      appfc('js_saveData', '_applysavedata', {}, '');
    })
  },
    mounted(){
      window._applyed = this._applyed;
      window._applysavedata = this._applysavedata;
    }
  }

</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  .apply
    position fixed
    top 0
    bottom 0
    width 100%
    height 100%
    overflow scroll
    .applycontain
      position relative
      top 10px
      bottom 0px
      width 100%
      overflow scroll
      section
        text-align center
        span
          display inline-block
          width 180px
          height 60px
          line-height 60px
          border: 1px solid #999999;
          border-radius: 8px;
          text-align center
          color #999999
          margin 10px 10px 20px
        span.active
          background: $color-theme;
          color white
          border: 1px solid $color-theme;
      ul
        li.bigli
          height 140px
          line-height 140px
        li:last-child
          margin-bottom 10px
        li + li
          border-top 1px solid $color-gap
        li
          width 95%
          margin 0 auto
          height $button-height
          line-height $button-height
          font-size 0
          h3
            width 30%
            text-align left
            display inline-block
            float left
          p
            width 70%
            text-align right
            display inline-block
            vertical-align middle
            span
              color $color-text
            i
              color #4CAAE6
              font-size 35px
              vertical-align middle
              margin-right 5px
            input
              text-align right
              height 25px
      p
        text-align left
        line-height 20px
        text-indent 5px
    .tip
      margin-top 30px
</style>

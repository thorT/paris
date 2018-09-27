<template>
  <div id="questions" class="navi">
    <MHeader :title="'常见问题'" :shadow="true"></MHeader>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" :data="info">
        <h1>常见问题</h1>
        <ul>
          <li v-for="item,index in info" @click.prevent="item.show=!item.show">
            <h5 class="line"></h5>
            <img class="deng" src="../../assets/image/deng.png" style="vertical-align:text-bottom;">
            <h2>{{item.title}}</h2>
            <img :class="[item.show?'transform arrow':'arrow']" src="../../assets/image/arrow.png">
            <h3 v-show="item.show" v-html="item.detail" transition="toggle">{{item.detail}}</h3>
          </li>
        </ul>
      </Scroll>
    </div>
    <div class="X_paddingbottom"></div>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Scroll from '@/components/public/scroll'

  export default {
    data() {
      return {
        contentH:0,
        info: [
          {show:false,title: '做了任务，奖励在哪里可以看到?', detail: '奖励回调后可以个人中心->我的账户中查看'},
          {show:false,title: '联盟任务是什么？', detail: '下载app，并符合广告主要求，获得体验奖励;'},
          {show:false,title: '市场调查是什么？',
            detail:'<span>100积分=1元,<br>'+ '想要奖励最大化？<br>你可以这样做:<br></span>' +
            '想象自己年龄在35-45岁之间，女性好一些，<br>--问你有车吗?你要说有，并在网上找辆70万左右的车记下车的信息，以备后面他再问；<br>' +
            '--问你住哪里?比如你说上海，后面他再问你时，你要说住在市区，住了5年或更久的时间<br>' +
            '--问你家里是你主事吗？你一定要说是<br>' +
            '--问你公司里你的地位？你就往管理层讲，比如采购主管等等<br>' +
            '--问你家里年收入多少？你一定要填高些，大概在55万以上，并找本本记录下来<br>' +
            '--问你太阳和地球的距离，请点击第二项？你就去点击第二项<br>' +
            '--问你2+7=？你一定要选择9<br>' +
            '-定要拿个小本本把你填重要的东西，比如：年龄，性别，有车的将车辆信息，等等记下来，不记录在小本本上，也一定要记在电脑的txt文件下，' +
            '反正一定要记下来<br>' +
            '--绝对不能今天填18岁，明天填20岁，这样随便填，这是大忌<br>' +
            '--每天获利至少10元以上，我说10元其实都是少的，20元，30元打底根本就没有问题<br>' +
            '--也可以粘贴链接在电脑上做，一天做好几百的多的是，真的是很赚钱，不过要认真填写，不能乱写；'},
          {show:false,title: '玩游戏任务是什么？', detail: '玩游戏就可以获得奖励的金桶任务'},
          {show:false,title: '月结是什么？', detail: '市场调查金额的结算方式是月结，到时间时会自动转入可提现金额中'},
          {show:false,title: '任务正规吗？', detail: '我们提供的商家均来自苹果正规渠道，绝对童叟无欺，请放心使用'},
        ]
      }
    },
    components: {
      MHeader,Scroll
    },
    methods: {
      goto(res) {

      }
    },
    mounted() {
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #questions
    width 100%
    background white
  .main
    width 100%
    h1
      font-size $font-size-medium
      color $color-text
      line-height 120px
      margin-left 30px
    ul
      width 100%
      li
        width 100%
        h5
          margin-left 30px
          margin-right 30px
          height 1px
          background $color-line-gray
        .deng
          display inline-block
          padding-top 20px
          margin-left 30px
          width 44px
          height 44px
        h2
          display inline-block
          height 44px
          line-height 44px
          padding-top 25px
          margin-bottom 20px
          color #666673
          font-size $font-size-small
        h3
          display inline-block
          margin 0px 30px 20px 80px
          line-height 39px
          color #3c3c44
          transition all 1s
          font-size $font-size-small
          overflow hidden
        .arrow
          float right
          width 18px
          height 30px
          margin-right 30px
          padding-top 30px

  span
    font-weight bold
  .toggle-enter
    height 0
    opacity 0
    padding 0 15px
  .toggle-leave
    height 0
    opacity 0
    padding 0 15px
  .transform
    margin-top 10px
    transform rotate(90deg)



</style>

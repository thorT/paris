<template>
  <transition name="confirm2-fade">
    <div class="confirm2" v-show="isShow" @click.stop>
      <div class="confirm2-wrapper">

        <div class="loader">
          <div class="dot"></div>
          <div class="dot"></div>
          <div class="dot"></div>
          <div class="dot"></div>
          <div class="dot"></div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script type="text/ecmascript-6">
  export default {
    props: {
      title: {
        type: String,
        default: '加载中'
      },
    },
    data() {
      return {
        isShow: false,
      };
    },
    methods: {
      // 确定,将promise断定为resolve状态
      show: function () {
        this.isShow = true;
      },
      close: function () {
        this.isShow = false;
      },
      destroy: function () {
        this.$destroy();
        document.body.removeChild(this.$el);
      }
    },
  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  body {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .confirm2
    position: fixed
    left: 0
    right: 0
    top: 0
    bottom: 0
    z-index: 998
    &.confirm2-fade-enter-active
      animation: confirm2-fadein 0.3s
      .confirm2-content
        animation: confirm2-zoom 0.3s
    .confirm2-wrapper
      position: absolute
      top: 50%
      left: 50%
      transform: translate(-50%, -50%)
      z-index: 999
      margin 0 auto

  @keyframes confirm2-fadein
    0%
      opacity: 0
    100%
      opacity: 1

  @keyframes confirm2-zoom
    0%
      transform: scale(0)
    50%
      transform: scale(1.1)
    100%
      transform: scale(1)
  .loader
    position relative
    top 50%
    left 40%
    transform translate3d(-50%, -50%, 0)

  .dot
    width 24px
    height 24px
    background #3ac
    border-radius 100%
    display inline-block
    animation slide 1s infinite

  for n in (1..5)
    .dot:nth-child({n})
      animation-delay (.1s * n)
      background red(#409EFF, (50 * n))

  @keyframes slide
    0%
      transform scale(1)
    50%
      opacity .3
      transform scale(2)
    100%
      transform scale(1)
</style>

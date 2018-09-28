<template id="tcdialog">
  <div class="dialog" v-if="showDialog">
    <div class="dialog_mask">
      <div class="dialog_container">
        <div class="dialog_content_top" v-html="msg">{{msg}}</div>
        <div class="dialog_btn">
          <div class="line"></div>
          <a href="javascript:;" class="btn" @click="yes">{{sure}}</a>
          <a href="javascript:;" class="btn" @click="cancel">取消</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/ecmascript-6">
  export default {
    props: {
      msg: {
        type: String,
      },
      sure: {
        type: String,
        default:'确定'
      },
      showDialog: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      yes() {
        this.$emit('sureAction')
      },
      cancel() {
        this.$emit('cancelAction')
      },
      used() {
        this.$emit('usedAction')
      }
    }
  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  .dialog_mask
    position fixed
    left 0
    top 0
    width 100%
    height 100%
    background rgba(0, 0, 0, 0.5)
    z-index 666

  .dialog_container
    background #f6f6f6
    position relative
    border-radius 35px
    margin 0 auto
    width 70%
    top 33%
    text-align center
    .dialog_content_top
      padding 30px 50px
      word-break break-all
      line-height 50px
      font-size $font-size-medium-x

  .dialog_btn
    width 100%
    position relative
    overflow hidden

  a
    display inline-block
    width 50%
    float left
    border-radius 5px
    color $color-theme
    border-top solid 1px $color-line-gray
    line-height 110px
  .line
    position absolute
    display inline-block
    margin-top:30px
    float left
    height 50px
    width 1px
    background $color-line-gray

</style>

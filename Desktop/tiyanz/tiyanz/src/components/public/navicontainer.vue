<template>
  <div id="navicontainer">
  </div>
</template>

<script type="text/ecmascript-6">
  export default {
    methods:{
      goback () {
        this.$router.go(-1)
      }
    }
  }
</script>


<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #navicontainer
    position relative
    top 0px
    left 0px
    width 100%
    height 128px
    background $color-theme
    text-align center
    box-shadow 1px 1px 2px #888
    h1
      display inline-block
      padding-top 20px
      height 44px
      line-height 44px

</style>

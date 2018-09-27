<template>
  <div class="loading">
    <img width="24" height="24" src="./loading.gif">
    <p class="desc gray">{{title}}</p>
  </div>
</template>
<script type="text/ecmascript-6">
  export default {
    props: {
      title: {
        type: String,
        default: ''
      }
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"

  .loading
    width: 100%
    text-align: center
    margin-top 10px
    .desc
      line-height: 20px
      font-size: $font-size-medium-x
      color: $color-text-d
</style>

<template>
    <div class="mli">
        <slot></slot>
    </div>
</template>
<script>
    export default{

    }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    .mli
      display block
      margin-top $li-gap
      ul
         font-size 0
         margin-top $li-gap
         background $color-background-content
         li + li
           border-top 1px solid $color-gap
         li
           height $button-height
           line-height $button-height
           width 92%
           margin 0 auto
           box-sizing border-box
           span
               display inline-block
               width 15%
               height 100%
               i
                font-size 22px
           p
              display inline-block
              width 70%
              height 100%
              font-size $font-size-medium
              text-align left
           span:first-child
              float left
              text-align left
           span:last-child
              float right
              text-align right
              i
               color $color-text-gray
               font-size $font-size-large
</style>
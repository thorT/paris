<template>
    <div class="income">
        <section v-for="day in incomeData">
            <h3 class="gray">{{day.date}}</h3>
            <ul>
                <li v-for="item in day.data">
                    <h2>{{item.title}}</h2>
                    <div>
                        <h4>+{{item.price}}¥</h4>
                        <h5 v-if="item.status&&item.status==1" class="orange">已到账</h5>
                        <h5 v-else class="gray">{{item.time}}</h5>
                    </div>
                    <span><i class="icon iconfont gray">&#xe608;</i></span>
                </li>
            </ul>
        </section>
    </div>
</template>
<script>
    export default{
        props: {
            incomeData: {
                type: Array,
                required: true
            },
        },
        data(){
            return {

            }
        },


    }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    .income
        section
            h3
             text-align left
             height 30px
             line-height 30px
             font-size $font-size-small
             text-indent 10px
            ul
              background $color-background-content
              li + li
                border-top:1px solid #E5E5E5;
              li
                height 65px
                line-height 65px
                font-size 0
                width 95%
                margin 0 auto
                h2
                  display inline-block
                  width 60%
                  float left
                  text-align left
                  font-size $font-size-medium
                  overflow: hidden
                  white-space: nowrap;
                  text-overflow: ellipsis
                div
                  display inline-block
                  width 30%
                  float left
                  height 100%
                  text-align right
                  h4
                    height 33px
                    font-size $font-size-large-x
                    line-height 42px
                    font-family PingFangSC-Semibold
                  h5
                    height 32px
                    font-size $font-size-small
                    line-height 22px
                span
                  display inline-block
                  width 10%
                  float left
                  height 100%
                  text-align right
                  i
                    font-size $font-size-large-x




</style>
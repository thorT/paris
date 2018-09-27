<template>
    <transition name="confirm2-fade">
        <div class="confirm2" v-show="showFlag" @click.stop>
            <div class="confirm2-wrapper">
                <div class="confirm2-content">
                    <p class="text">{{text}}</p>

                </div>
            </div>
        </div>
    </transition>
</template>

<script type="text/ecmascript-6">
    export default {
        props: {
            text: {
                type: String,
                default: ''
            },

        },
        data() {
            return {
                showFlag: false
            }
        },
        methods: {
            show() {
                this.showFlag = true
                let _self=this
                setTimeout(function(){
                    _self.showFlag=false;
                },2000)
            },
        }
    }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    .confirm2
        position: fixed
        left: 0
        right: 0
        top: 0
        bottom: 0
        z-index: 998
        background-color: $color-background-d
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
            .confirm2-content
                border-radius: 8px
                background: rgba(0,0,0,0.5)
                .text
                    padding: 0px 10px
                    line-height: 44px
                    height: 44px
                    text-align: center
                    font-size: 24px
                    color:white

    @keyframes confirm2-fadein
        0%
            opacity: 0
        20%
            opacity: 0.7
        100%
            opacity: 1

    @keyframes confirm2-zoom
        0%
            transform: scale(0)
        50%
            transform: scale(1.1)
        70%
            transform: scale(1)
        90%
            transform: scale(1.06)
        100%
            transform: scale(1)
</style>

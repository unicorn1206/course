import Vue from 'vue'
import App from './App.vue'
import router from './router'
import axios from 'axios'

Vue.config.productionTip = false;
//Vue组件的全局变量。可以在任意vue组件中，使用this.xxx来获取这个值，$代表vue全局属性的约定
Vue.prototype.$ajax = axios;

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')

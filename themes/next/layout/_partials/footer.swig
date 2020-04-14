<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.footer.icon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>

  
</div>

{% if theme.footer.powered %}
  <div class="powerd by">{#
  #}{{ __('footer.powered', '<a class="theme-link" target="_blank" href="https://github.com/inspurer/inspurer.github.io">月小水长</a>') }}{#
#}</div>
{% endif %}

{% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">总字数:</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %}

{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}

{% if theme.footer.theme.enable %}
	<span>
		<i class="fa fa-eye"></i>
	</span>
<script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
总浏览量:<span id="busuanzi_value_site_pv"></span>
{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}
<span><i class="fa fa-user"></i></span>
总访客数:<span id="busuanzi_value_site_uv"></span>
{% endif %}
{% if config.symbols_count_time.total_symbols %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.symbols_count_time.item_text_total %}
      <span class="post-meta-item-text">{{ __('symbols_count_time.count_total') + __('symbol.colon') }}</span>
    {% endif %}
	<span title="{{ __('post.totalcount') }}">
     {{ totalcount(site, '0,0.0a') }}字 </span>
    <!--<span title="{{ __('symbols_count_time.count_total') }}">{{symbolsCountTotal(site)}}</span>-->
  {% endif %}
<div class="powerd by">
   {% if theme.footer.theme.enable %}
<span id="timeDate">载入天数...</span><span id="times">载入时分秒...</span> 
<script> 
	var now = new Date(); 
	function createtime() { 
		var grt= new Date("06/07/2018 20:15:00");//此处修改你的建站时间或者网站上线时间 
		now.setTime(now.getTime()+250); 
		days = (now - grt ) / 1000 / 60 / 60 / 24; dnum = Math.floor(days); 
		hours = (now - grt ) / 1000 / 60 / 60 - (24 * dnum); hnum = Math.floor(hours); 
		if(String(hnum).length ==1 ){hnum = "0" + hnum;} minutes = (now - grt ) / 1000 /60 - (24 * 60 * dnum) - (60 * hnum); 
		mnum = Math.floor(minutes); if(String(mnum).length ==1 ){mnum = "0" + mnum;} 
		seconds = (now - grt ) / 1000 - (24 * 60 * 60 * dnum) - (60 * 60 * hnum) - (60 * mnum); 
		snum = Math.round(seconds); if(String(snum).length ==1 ){snum = "0" + snum;} 
		document.getElementById("timeDate").innerHTML = "已安全运行 "+dnum+" 天 "; 
		document.getElementById("times").innerHTML = hnum + " 小时 " + mnum + " 分 " + snum + " 秒"; } setInterval("createtime()",250); </script>
{% endif %}
</div>



{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}

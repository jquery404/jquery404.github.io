---
layout: portfolio
title: jQuery404 | Portfolio 
permalink: /portfolio/
---



<section id="portfolio">
	<div class="container">
		<div class="row clearfix mosaicflow">
		{% for post in site.posts %}			
			{% if post.thumbnail %}
			<div class="mosaicflow__item"><a href="{{ post.permalink }}"><img src="..{{ post.thumbnail }}" alt=""><p>{{ post.title }}</p></a></div>
			{% else %}
			<div class="mosaicflow__item" style="background-image:url('http://placehold.it/200x800')"></div>
			{% endif %}
		{% endfor %}	
		</div>
	</div>
</section>
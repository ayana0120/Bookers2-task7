// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require bootstrap-sprockets
//= require_tree .

// 郵便番号での住所自動入力
$(document).on('turbolinks:load', function() {
	$(function() {
	  return $('#user_postcode').jpostal({
	    postcode: ['#user_postcode'],
	    address: {
	      '#user_prefecture_code': '%3',
	      '#user_city': '%4',
	      '#user_street': '%5%6%7',
	    },
	  });
	});
});

// 地図の取得
function initMap() {
	var test ={lat: <%= user.latitude %>, lng: <%= user.longitude %>};
	var map = new google.maps.Map(document.getElementById('map'), {
	          zoom: 15, 
	          center: test
	          });
	var transitLayer = new google.maps.TransitLayer();
	transitLayer.setMap(map);

	var infowindow = new google.maps.InfoWindow({
	  content: contentString
	});

	var marker = new google.maps.Marker({
	              position:test,
	              map: map,
	              title: contentString
	             });

	marker.addListener('click', function() {
	 infowindow.open(map, marker);
	});
}
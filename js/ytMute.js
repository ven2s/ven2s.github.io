//usage <iframe id="ytplayer" ></iframe>

var tag = document.createElement('script');
 
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[10];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
 
    var player;
 
    function onYouTubeIframeAPIReady() {
        player = new YT.Player('ytplayer', {
            events: {
                'onReady': onPlayerReady
            }
        });
    }
 
    function onPlayerReady() {
        //player.playVideo();
        // Mute!
        player.mute();
    }



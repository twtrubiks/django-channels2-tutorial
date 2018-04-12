# django-channels2-tutorial

 django-channels2-tutorial 💬

* [Youtube Tutorial Part1 - django channels2 demo 以及簡介](https://youtu.be/jIMtZkfs8yY)

* [Youtube Tutorial Part2 - django channels2 tutorial](https://youtu.be/_4Q801WL8sA)

## 前言

最近剛好想玩一下聊天室，於是就找到 [Channels](https://github.com/django/channels)，也從 [releases](https://github.com/django/channels/releases) 這裡發現在今年 2 月的時候 **Channels 2**

被 releases 出來，所以決定簡單整理一篇介紹給大家。

透過 Django [Channels](https://github.com/django/channels) 建立簡單的聊天室範例，此範例為官方的 [Tutorial](https://channels.readthedocs.io/en/latest/tutorial/index.html)，希望能透過這個簡單的範例，讓大

家更了解 Channels，我有稍微修改一些部分，官方範例是使用  Channels 2.0 ,  Python 3.5+ , Django 1.11，

我這邊最主要的是將他修改為 Django 2.0。

注意，Channels 1 和 Channels 2 有蠻大的差異，這邊都是講 Channels 2，詳細可參考 [What’s new in Channels 2?](https://channels.readthedocs.io/en/latest/one-to-two.html)

之前，我也有使用過 flask 寫過聊天室，可參考 [chat-room](https://github.com/twtrubiks/chat-room)。

讓我們先來看看執行的畫面吧:laughing:

## 執行畫面

輸入一個名稱建立聊天室群組，直接瀏覽 [http://localhost:8000/chat/](http://localhost:8000/chat/)

![alt tag](https://i.imgur.com/WSZEJNU.png)

接著可以在聊天室裡面打字

![alt tag](https://i.imgur.com/sraj4Ls.png)

同一個聊天室群組會互相收到訊息，不同的聊天室群組訊息 **不會互通**，

![alt tag](https://i.imgur.com/JDD0JYb.png)

我知道這個聊天室真的非常的醜:joy:，而且也沒搭配 database，但這篇只是一個要讓大家了解 Channels

如何建立一個聊天室，下一篇文章，我會依照這篇為雛形，建立一個有簡單的登入註冊系統以及美化過的

聊天室給各位，如果大家等不及想先搶先看，可瀏覽 [django-chat-room](https://github.com/twtrubiks/django-chat-room)。

但建議這篇文章還是要看，因為我將介紹一些基本的概念以及互動的流程。

## 如何執行

確認電腦有安裝 docker 後，直接執行以下指令即可，

```cmd
docker-compose up
```

![alt tag](https://i.imgur.com/jTFNXoH.png)

如何移除 ( 包含移除 volume )，

```cmd
docker-compose down -v
```

## 簡介

這邊先介紹幾個名詞，我不會講的非常詳細，因為大家可以用關鍵字去 google ，很多文章都解釋非常清楚了:grin:

### WebSocket

WebSocket 是一種單一 TCP 連線上進行全雙工（full-duplex）通訊管道，可以讓網頁與伺服器之間做即時性、

雙向的資料傳遞。

Websocket 需要先建立連線，需要通過瀏覽器發出請求，之後伺服器進行回應，這段過程稱為 **交握**（ handshaking ）。

延伸閱讀，如果大家有興趣，可以再去看看 polling ( 輪詢 ) 的概念。

### Channels

本次的主角，你可以把 Django 想成是 synchronous ( 同步 )，而透過 Channels，可以改變

Django synchronous（ 同步）的核心轉變為 asynchronous（非同步）的程式碼。

以下擷取官方文件

channels allowing Django projects to handle not only HTTP, but protocols that require long-running connections too WebSockets, MQTT, chatbots, amateur radio, and more.

it provides integrations with Django’s auth system, session system, and more, making it easier than ever to extend your HTTP-only project to other protocols.

channels 支持很多協定，而且也整合了 Django 的 auth 以及 session 系統等等。

### ASGI

ASGI 全名為 Asynchronous Server Gateway Interface，

他是 WSGI 的精神繼承者，不只是使用 `asyncio` 異步的方法運行，而且也支援多種協定。

更多說明可參考 [ASGI](https://channels.readthedocs.io/en/stable/asgi.html)。

## 教學

我將簡單說明這個範例的流程，但詳細的介紹，我還是非常建議大家觀看官方的 [Tutorial](https://channels.readthedocs.io/en/latest/tutorial/index.html) 範例。

### 建立環境

這部份只是和大家說明基本的環境設定，其實直接 `docker-compose up` 即可，因為我都幫大家包成 docker 了，

解決了環境的問題（ 像我在 windows 上 `channels` 一直裝不起來 :expressionless:）。

首先， 我使用的 Python 版本為 3.6.4，

安裝套件

```cmd
pip install -r requirements.txt
```

[requirements.txt](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/requirements.txt)

```txt
Django==2.0.4
channels==2.0.2
channels_redis==2.1.1
```

使用 Django 2.0.4 以及 channels 2.0.2，channels_redis 2.1.1 為 `CHANNEL_LAYERS` 中的 `BACKEND` 需要使用到的。

### 用 docker 建立 redis

這部份只是和大家說明基本的環境設定，其實直接 `docker-compose up` 即可，因為我都幫大家包成 docker 了，

解決了環境的問題（ 像我在 windows 上 `channels` 一直裝不起來 :expressionless:）。

因為這邊會使用到 redis，所以使用 docker 建立 redis，如果不了解 docker 以及 redis ，

可參考下面這兩篇文章，分別介紹了 docker 以及 redis

* [Docker 基本教學 - 從無到有 Docker-Beginners-Guide](https://github.com/twtrubiks/docker-tutorial)

* [django-docker-redis-tutorial 基本教學](https://github.com/twtrubiks/django-docker-redis-tutorial)

建立 redis 指令，

```cmd
docker run --name some-redis  -p 6379:6379  -d redis redis-server --appendonly yes
```

### channels installation

接下來將介紹 channels 的設定，官方文件可參考 [installation](https://channels.readthedocs.io/en/latest/installation.html)，

將 channels 加入 INSTALLED_APPS，

django_channels2_tutorial/[settings.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/django_channels2_tutorial/settings.py)

```python
INSTALLED_APPS = [
    ....
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'channels',
    'chat',
]
```

溫馨小提醒:heart:

`channels` 官方範例會將他放在最前面的原因是，有些套件會衝突，所以將他放到第一順位這樣。

chat 是我們建立的（ 後面會介紹 ），

接著建立 default routing，

django_channels2_tutorial/[routing.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/django_channels2_tutorial/routing.py)

```python
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter

import chat.routing

application = ProtocolTypeRouter({
    # Empty for now (http->django views is added by default)
    'websocket': AuthMiddlewareStack(
        URLRouter(
            chat.routing.websocket_urlpatterns
        )
    ),
})
```

`chat.routing` 以及 `chat.routing.websocket_urlpatterns` 是我們自己建立的（ 後面會介紹 ），

設定 channel settings，

django_channels2_tutorial/[settings.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/django_channels2_tutorial/settings.py)

```python
ASGI_APPLICATION = "django_channels2_tutorial.routing.application"
CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels_redis.core.RedisChannelLayer',
        'CONFIG': {
            'hosts': [('redis', 6379)],
        },
    }
}
```

`ASGI_APPLICATION` 設定為自己的 project 名稱 ( 這裡我們命名為 `django_channels2_tutorial` )，

指向底下的 routing（ 我們剛剛建立的 ）裡的 application（ 剛剛建立的 ），所以完整名稱為

`django_channels2_tutorial.routing.application`。

`CHANNEL_LAYERS` 中的 `BACKEND` 設定為 redis ，也就是為什麼我們前面要安裝 `channels_redis` 的原因，

`CONFIG` 就是設定連線 redis 字串，是不是很好奇為什麼 `host` 的部份我直接寫 `redis`？

( 其實就是 [docker-compose.yml](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/docker-compose.yml) 中的 redis 名稱 )。

如果大家還是不了解，建議可以閱讀 [這篇](https://github.com/twtrubiks/docker-tutorial#user-defined-networks) 的說明。

### 說明

剛剛上面提到了 [chat](https://github.com/twtrubiks/django-channels2-tutorial/tree/master/chat) 資料夾，接下來讓我們來看看 [chat](https://github.com/twtrubiks/django-channels2-tutorial/tree/master/chat) 做了什麼事情，

chat/[views.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/views.py)

```python
import json

from django.shortcuts import render
from django.utils.safestring import mark_safe

def index(request):
    return render(request, 'chat/index.html', {})


def room(request, room_name):
    return render(request, 'chat/room.html', {
        'room_name_json': mark_safe(json.dumps(room_name))
    })
```

chat/[urls.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/urls.py)

```python
# chat/urls.py
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('<str:room_name>/', views.room, name='room'),
]
```

這邊很簡單，就是定義好 views 以及 url 而已，比較需要注意的是 url 的部份，

因為我們使用的是 `django 2.0`，所以已經改用 `path` 了，其實總體來說，我

覺得`django 2.0` 在處理 url 上更方便了，以前要寫正則表達式:scream:。

我們來看一下比較重要的 consumers，

詳細的介紹，可參考官網說明 [consumers](https://channels.readthedocs.io/en/stable/topics/consumers.html)，

這裡先給大家簡單的觀念，consumers 是在 Channels 中的一個基本單位，當一個 request 或 socket 進來時，

Channels 會去找他的 routing table，找到對的 consumers，基本上，consumers 就像是 Django 中的 views。

consumers 有兩個點要和大家提一下（ 擷取官方說明 ），

* Structures your code as a series of functions to be called whenever an event happens, rather than making you write an event loop.

* Allow you to write synchronous or async code and deals with handoffs and threading for you.

先來看 chat/[routing.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/routing.py)，

```python
from django.urls import path

from . import consumers

websocket_urlpatterns = [
    path('ws/chat/<str:room_name>/', consumers.ChatConsumer),
]
```

定義了 websocket_urlpatterns，並且設定 `ChatConsumer` class，

那我們在哪邊定義這個 routing 呢 ？

django_channels2_tutorial/[routing.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/django_channels2_tutorial/routing.py)

```python
from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter

import chat.routing

application = ProtocolTypeRouter({
    # Empty for now (http->django views is added by default)
    'websocket': AuthMiddlewareStack(
        URLRouter(
            chat.routing.websocket_urlpatterns
        )
    ),
})
```

root routing 設定的地方就是在前面介紹的 django_channels2_tutorial/[routing.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/django_channels2_tutorial/routing.py)，

也就是上面的 `chat.routing.websocket_urlpatterns`。

接下來看 chat/[consumers.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/consumers.py)，

```python
import json

from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer


class ChatConsumer(WebsocketConsumer):
    def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = 'chat_%s' % self.room_name

        # Join room group
        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name,
            self.channel_name
        )

        self.accept()

    def disconnect(self, close_code):
        # Leave room group
        async_to_sync(self.channel_layer.group_discard)(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']

        # Send message to room group
        async_to_sync(self.channel_layer.group_send)(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message
            }
        )

    # Receive message from room group
    def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        self.send(text_data=json.dumps({
            'message': message
        }))
```

以上是使用 synchronous（ 同步 ）的方法。

接著將介紹他們互動的流程（ 事件如何觸發 ），

`connect`

當前端發 Websocket 過來的時候會觸發此事件，

那前端哪時候會送訊息過來呢 ？

我們來看 chat/templates/chat/[room.html](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/templates/chat/room.html)，

```javascript
...
<script>
    var roomName = {{ room_name_json }};

    var chatSocket = new WebSocket(
        'ws://' + window.location.host + '/ws/chat/' + roomName + '/');
    ...
</script>
```

當前端 WebSocket 初始話連線的時候，會觸發 `connect`。

接下來說明 `connect` 中的一些方法，

首先是 `self.scope` 這個，你可以把它想成像是 Django 裡的 `self.request`，

而 `url_route` 則是抓取 url，我們取出 `room_name` ，為什麼是 `room_name` ，

原因是我們在 chat/[urls.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/urls.py) 中設定 `urlpatterns` 變數為  `room_name`，

chat/[urls.py](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/urls.py)

```python
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('<str:room_name>/', views.room, name='room'),
]
```

接下來我們透過 `async_to_sync` 把 channel 加入 group 中，channel 和 group 的關係也不用想的太複雜，

其實他們的關係就是一個 group 中，可以有很多個 channel 這樣。

最後是 `self.accept()` 這個，就是接受這個連線，如果要拒絕這次的連線，使用 `self.close()` 即可。

`disconnect`

將 channel 從 group 中移除，

我們來看 chat/templates/chat/[room.html](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/templates/chat/room.html)

```javascript
...
<script>
    ....
    chatSocket.onclose = function(e) {
        console.error('Chat socket closed unexpectedly');
    };
    ....
</script>
```

當 server 端的 WebSocket 關閉時，前端的 `chatSocket.onclose` 會被觸發。

`receive`

當我們收到來至前端的 WebSocket 訊息時，

那前端哪時候會送訊息過來呢 ？

我們來看 chat/templates/chat/[room.html](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/templates/chat/room.html)

```javascript
...
<script>
    ....
    document.querySelector('#chat-message-submit').onclick = function(e) {
        var messageInputDom = document.querySelector('#chat-message-input');
        var message = messageInputDom.value;
        chatSocket.send(JSON.stringify({
            'message': message
        }));

        messageInputDom.value = '';
    };
</script>
```

`chatSocket.send` 就會觸發這個事件，`receive` 將收到的 message 送到對應的
group 中，

`type` 就是指 `chat_message`。

`chat_message`

當從 group 中收到 message 時，會觸發這個事件，我們將收到的 message 送回前端的 WebSocket，

那前端誰接收的？

我們來看 chat/templates/chat/[room.html](https://github.com/twtrubiks/django-channels2-tutorial/blob/master/chat/templates/chat/room.html)

```javascript
...
<script>
    ....
    chatSocket.onmessage = function(e) {
        var data = JSON.parse(e.data);
        var message = data['message'];
        document.querySelector('#chat-log').value += (message + '\n');
    };
    ....
</script>
```

`chatSocket.onmessage` 會收到訊息，前端再將訊息增加到畫面上。

以上，就是整個前後端 WebSocket 事件互動的流程。

### Rewrite Chat Server as Asynchronous

官網可參考 [Tutorial Part 3](https://channels.readthedocs.io/en/latest/tutorial/part_3.html)，

剛剛是使用 synchronous（ 同步 ）的方法，現在我們要改寫他為 asynchronous（ 非同步）的方法，

```python
import json
from channels.generic.websocket import AsyncWebsocketConsumer


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = 'chat_%s' % self.room_name

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # Receive message from WebSocket
    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']

        # Send message to room group
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message
            }
        )

    # Receive message from room group
    async def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        await self.send(text_data=json.dumps({
            'message': message
        }))

```

官網的最後一部分是 [Automated Testing](https://channels.readthedocs.io/en/latest/tutorial/part_4.html)，這部份我就沒有寫了，如果各位有興趣，就請再自行前往閱讀。

## 後記

這次和大家解釋了利用 channels 建立出的簡易版 chat room，也說明了他們互動的方式以及過程，

希望可以對 channels 有基礎的認識，如果意猶未盡，可以參考下一篇結合 database 以及美化的聊天

室，基本上是用這篇的教學延伸出去的，可參考 [django-chat-room](https://github.com/twtrubiks/django-chat-room) 。

## 執行環境

* Python 3.6.4

## Reference

* [Django](https://www.djangoproject.com/)
* [Channels](https://github.com/django/channels)

## Donation

文章都是我自己研究內化後原創，如果有幫助到您，也想鼓勵我的話，歡迎請我喝一杯咖啡:laughing:

![alt tag](https://i.imgur.com/LRct9xa.png)

[贊助者付款](https://payment.opay.tw/Broadcaster/Donate/9E47FDEF85ABE383A0F5FC6A218606F8)

## License

MIT licens

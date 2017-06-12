---
layout: post
comments: true
# other options
title:  "[공부해서남주기] Firebase 실시간 데이터베이스 #2"
date:   2017-04-20 02:29:00
categories: [Study]
tags : [공부해서남주기, Firebase, Swift, RealtimeDatabase]
---

안녕하세요! 웬스(ven2s)입니다. 오늘은 Firebase 실시간 데이터베이스 기본기능에 대해서 알아보려고 합니다.

일단 이 포스팅은 iOS, Swift의 기본을 어느정도 익히신분을 대상으로 작성되었습니다.

그리고 설정에 관한 부분은 공식 홈페이지가 더 잘나와 있기 때문에 별도로 작성하지 않겠습니다.

그전에 앞서서 <font color="red">import</font><font color="brown"> Firebase</font>
를 선언해주시고 

전역 변수로 아래와 같이 선언을 해주세요
```swift
var ref : FIRDatabaseReference! = FIRDatabase.database().reference()
```
기본적인 설정인 AppDelegate.swift 파일내의 설정과 Info.plist를 프로젝트에 넣으셨다면 정상적으로 작동이 될껍니다. 만약 안된다면... 설정하는 부분을 차근히 해보시길 권장 드립니다.

다시 한번 말씀드리지만 설정에 대한 부분은 공식홈페이지가 더 자세히 나와 있으니 따로 설명은 하지 않겠습니다.

그럼 시작 해보도록 할까욧!!!

## 1. Firebase 실시간데이터베이스 읽기

저번 포스팅에서 언급을 했듯이 Firebase(이하 파베)는 Document형테이고 트리구조라고 말씀을 드렸습니다.<br>
그렇기 때문에 지금 미리 선언된 ref 변수를 사용한다고 해도 전체를 가져오게 될껍니다.

그래서 child([명칭]) 을 사용해서 특정 노드에 들어가 데이터를 읽고 축적을 할수 있습니다.<br>
여기서는 Board라는 노드를 가지고 설명을 하겠습니다

그래서 우리들은 아래와 같이 선언을 해주고 시작을 할껍니다.

```swift
var boardRef = ref.child("Board")
```

위와 같이 선언을 하셔도 되고 아예처음 부터 합쳐도 괜찮습니다. 하지만 다른 노드를 호출할일이 있을지도 모르니 일단은 위에와 같이 선언하도록 합시다

자 그럼 이제 읽기에 대한 부분을 이야기 해보려고 합니다.

읽기는 기본적으로 2개의 함수를 제공을 해주는데 아래와 같습니다

```swift
//호출
func observe(_ eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Swift.Void) -> UInt

//한번호출
func observeSingleEvent(of eventType: FIRDataEventType, with block: @escaping (FIRDataSnapshot) -> Swift.Void)
```

기본적으로 파베는 비동기를 지원하고 있습니다. 그리고 FIRDataEventType 에 따라 호출될수 있도록 선언 할 수 있습니다. 

또한 계속 호출 할건지 최초 한번만 호출을 할껀지까지 제공을 해주고 있습니다.

하지만 역시 주의해서 사용을 해야 합니다. 저희가 노드를 나눠서 사용을 하고 있지만 계속 추가가 되고 있다면 사용자 측면에서는 통신비가 증가 할수가 있습니다. 잘 구분해서 쓰시길 권장 드립니다.

그럼 이벤트 타입에 대해서 알아보도록 하겠습니다.

타입 | 설명 
------- | -------------
value | 데이터 전체를 가지고 옵니다
childAdded | 노드에서 부터 추가되는 데이터를 감지합니다.
childRemoved  |  노드에서 부터 삭제되는 데이터를 감지합니다.
childChanged  | 노드에서 부터 변경되는 데이터를 감지합니다.
childMoved  | 노드에서 부터 이동하는 데이터를 감지합니다.

위에 같이 이벤트에 관련된 부분을 적절히 사용 하시면 됩니다.
미리 언급을 했듯이 주의 하셔야 하는 부분도 있습니다.
observeSingle을 쓸것인가? observe를 쓸것인가를 잘 판단하시길 바랍니다.

일단 가장 많이 사용 되는 부분인  value 데이터를 그냥 가지고 온다고 생각하시면 됩니다.
가능하면 싱글을 사용하셔서 하시는걸 추천 드리겠습니다. 

그냥 observe를 사용할 경우 계속 호출이 되는 경우가 있었기 때문에 value는 obserSingleEvent로 호출하시길 권장 드립니다(반드시는 아닙니다. 상황에 따라서는 observe를 쓰셔야 할수도 있어요)

그리고 여기서 또 언급 하고 가야 하는 부분은 FIRDataSnapshot(이하 스냅샷)일것 같습니다.
이 스냅샷은 데이터가 가져오는 형태라고 생각하시면 됩니다. 기존의 데이터베이스는 JSON으로 되어 있습니다.
스냅샷을 사용 하면 Swift에 맞도록 SDK에서 제공을 해줍니다. Dictionary타입으로 리턴이 됩니다.

```swift
let value = snapshot.value as! [String:Any]
```

가장 좋은건 역시 break point를 걸어서 로그 커맨드라인 명령어를 통해서 확인해보시면 JSON형식으로 찍혀 있습니다. 그런데 문제는 iOS에서 가장 많이 사용 되는 Array타입으로는 변환을 하려면 어떻게 하는게 좋을까요? Enumerated 를 사용해서 변환을 하면 됩니다. 

```swift
var tempList : Array<Any>! = Array() //초기화
            
let enumerated = snapshot.children
while let rest = enumerated.nextObject() as? FIRDataSnapshot {
    var key = rest.key //String
    var dictionary = rest.value as! [String : Any]

    tempList.append(dictionary)
}
```

위에 코드는 Firebase 실시간데이터베이스 예제 프로젝트에서도 사용하는 방식입니다.(코드는 똑같지 않을수도 있습니다.)

이렇게 사용을 하신다면 기본적인 Dictionary 와 Array 타입으로 변환하시기 편하실껍니다.
여기서 나오는 **key**는 사실 중요한 부분입니다. 이부분은 이 아래 2번쨰 쓰기(저장)을 할때 다루도록 하겠습니다.

## 2. Firebase 실시간데이터베이스 쓰기
기존의 데이터를 저장 하기 위해서는 3가지 정도의 방법이 있습니다. 그리고 고유값을 사용하기 위해서 사용하는 메소드 총 4개가 있습니다.

메소드명 | 기능(혹은 용도)
------ | -----------
childByAutoId | 고유값 생성
setValue | 데이터를 저장할때
updateChildValues | 데이터를 수정 혹은 저장 할때
runTransactionBlock | 데이터를 순차적으로 저장 수정 해야 할때 (예 : 페북 좋아요)

첫째로는 childByAutoId 는 고유값을 생성을 해주는 메소드 입니다. 
간단하게 말하자면 key를 생성해주는 녀석입니다. 데이터베이스를 사용하다면 특정 값을 찾기 위해서 혹은
비교하기 위해서 등의 이유로 고유키를 사용하게 됩니다 (게시판으로 치면 게시번호라고 보시면 됩니다.)

그렇기 떄문에 이 글이 중복이 나지 않게 하거나, 혹은 특정값을 찾기 혹은 증명하는 용도로 많이 사용합니다. 
여기서는 key라고 부르도록 하겠습니다. (이하 key 혹은 키)

전번에도 말씀드렸듯이 Document타입인 파베 실시간데이터베이스는 트리형태의 구조를 가지고 있고,
JSON 형태를 사용하고 있습니다. 그렇기 때문에 수많은 값을 증명하고 고유값을 부여해야 한다는 겁니다.

사용법은 아래와 같습니다.
```swift
let ref : FIRDatabaseReference! = FIRDatabase.database().reference().child("board")
let key = ref.childByAutoId().key //String
```

생각보다 간단합니다. (* 반드시 하나의 노드를 생성해서 사용하세요. child({노드이름}))

이제 드디어 저장을 써보도록 하겠습니다.
기본적으로 노드는 board로 잡아 놓고 시작을 하도록 하겠습니다.

```swift
let ref : FIRDatabaseReference! = FIRDatabase.database().reference().child("board")

let data : [String : Any] = [
    "key" : ref.childByAutoId().key,
    "title" : "test",
    "text" : "테스트로 일단 넣는 글입니다.",
    "recordTime" : FIRServerValue.timestamp()
]

ref.setValue(data, withCompletionBlock: { (error, ref) in
    if let err = error {
       print(err.localizedDescription)
    }

    ref.observe(.value, with: { (snapshot) in
        guard snapshot.exists() else {
            return
        }
        //코드 작성
    }
})
```

만약 컴플리션 블록을 안쓸 예정이라면 data 만 넣어주셔도 됩니다. (singleobserve가 아닐경우)
그리고 setValue는 업데이트를 할때도 사용이 가능합니다.

updateChildValues 에 대해서 해보려고 합니다.
함수명에서도 나와있듯이 업데이트를 할경우에 많이 사용이 되는 구문입니다. 다만 차이가 조금 있다면 
아래 코드를 봅시다

```swift
let userID = FIRAuth.auth().currentUser.uid
let key = ref.child("board").childByAutoId().key
let post = ["uid": userID,
            "author": username,
            "title": title,
            "body": body]
let childUpdates = ["/board/\(key)": post,
                    "/user-posts/\(userID)/\(key)/": post]
ref.updateChildValues(childUpdates)

```

 위의 코드와 같이 여러개의 노드를 동시에 해야 할경우에는 위에와 같이 사용하시면 됩니다.

 여기서 중요한 부분이 있는데 실시간 데이터 베이스다 보니 여러명의 사용자가 특정 글을 수정을 하게 될경우에는 (예시 댓글 혹은 좋아요 표현) 문제가 있을수 있습니다. (실시간의 특성의 문제죠)

 그렇기 때문에 runTransactionBlock을 사용 하면 됩니다. 이 함수는 순차적으로 데이터를 덮어 씌워줍니다. 그렇기 때문에 여러명이 한글에 대해서 댓글을 달거나 좋아요 표현을 할경우 순서대로 처리해줍니다.

 ```swift
ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
  if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
    var stars : Dictionary<String, Bool>
    stars = post["stars"] as? [String : Bool] ?? [:]
    var starCount = post["starCount"] as? Int ?? 0
    if let _ = stars[uid] {
      // Unstar the post and remove self from stars
      starCount -= 1
      stars.removeValueForKey(uid)
    } else {
      // Star the post and add self to stars
      starCount += 1
      stars[uid] = true
    }
    post["starCount"] = starCount
    post["stars"] = stars

    // Set value and report transaction success
    currentData.value = post

    return FIRTransactionResult.successWithValue(currentData)
  }
  return FIRTransactionResult.successWithValue(currentData)
}) { (error, committed, snapshot) in
  if let error = error {
    print(error.localizedDescription)
  }
}
 ```

중요한 부분은 마지막 리턴을 해야 하는 부분을 ```FIRTransactionResult.successWithValue(currentData)``` 사용해서 넣어주면 됩니다. 코드로만으로도 충분하다고 생각하기 때문에 생략하겠습니다.
코드는 개인이 작성한 코드도 있고 파베 공식부분에서도 나오는 부분을 섞어서 사용을 했습니다.

어느정도 저장에 대해서 이해가 되셨는지 모르겠네요 기능 위주의 설명이다 보니 설명이 부족할 수 있습니다. 
Document를 참고하시거나 댓글에 추가적으로 질문을 해주셔도 됩니다.

## 3. Firebase 실시간데이터베이스 삭제

이번엔 삭제에 대해서 알아보려고 합니다. 완전삭제 입니다. 이부분에 대해서는 확실하게 해주고 넘어가야 겠네요
간혹 서비스의 정책으로 인해서 몇개월 혹은 몇년동안 데이터를 유지해야 할경우에는 다른 방법으로 하시고 이녀석은 정말로 데이터의 완전 삭제 입니다. 그렇기 때문에 가능하면 유저에게 알림을 통해서 완전삭제의 메세지를 통해서 복구가 안됨을 고지 하셔야 합니다.

사용법은 어렵지 않습니다

```swift
//키값이 필수이다. (단, 코드에서는 노드 위치와 고유키값을 생략함)
ref.child(key!).removeValue(completionBlock: { (err, ref) in
    if err != nil {
        debugPrint("failed to remove reply")
        return
    }
})

```

위의 코드와 같이 삭제할때는 키값만 있으면 삭제가 됩니다. 그리고 확실하게 노드도 구분을 해줘야 한다.
보통은 고유키 값이라서 중복된 부분이 있을리가 만무하지만 혹모르는 일이니 꼭 노드까지 다 붙여서 사용하시길 바랍니다.



## 4. Firebase 실시간데이터베이스 기타

이 부분에서는 검색과 부족한 점에 대해서 말해볼까 합니다.
일단 파베의 경우에는 조건에 대한 부분이 참 까다롭습니다. 특정 값의 대한 필터가 사실상 어렵습니다.

SQL을 사용한다면 Where구문을 사용해서 원하는 조건을 찾아 주겠지만 여기서는 사실상 필터링을 앱에서 해야 합니다. 

기본적으로 파베에서는 정렬은 제공을 해줍니다.

**키, 값 , 자식(child)** 3가지를 제공을 해줍니다.

ref를 선언하고 나서 아래 표의 3가지중 하나를 사용 하시면 됩니다.

메소드명 | 설명
---- | ----
queryOrderedByKey | 하위 키에 따라 결과를 정렬합니다.
queryOrderedByValue | 하위 값에 따라 결과를 정렬합니다.
queryOrderedByChild | 지정된 하위 키의 값에 따라 결과를 정렬합니다.

```swift
var ref = FIRDatabaseReference! = FIRDatabase.database().reference().child("board").queryOrderedByChild("createTime")
```

게시판을 기준으로 하게 된다면 **createTime(생성시간)** 기준으로 정렬을 하면 될것 같습니다.
기본적으로는 사전순, 오름차순 순으로 정렬이 됩니다.

그럼 내림차순은 어떻게 써야 할까요? 
아쉽게도 이런 것은 제공이 안됩니다. 그렇기 때문에 클로저를 이용해서 따로 처리를 해주셔야 합니다

```swift
var yourDataArray
yourDataArray.sort({$0.date > $1.date})
```

**sort()**메소드는 swift에서 제공하는 옵션입니다. 자세한것은 다루지 않겠습니다.

데이터필터링을 하기 위해서는 아래와 같은 표의 옵션들이 있습니다.

필드명 | 용도
---- | ----
queryLimitedToFirst | 정렬된 결과 목록에서 맨 처음부터 반환할 최대 항목 개수를 설정합니다.
queryLimitedToLast | 정렬된 결과 목록에서 맨 끝부터 반환할 최대 항목 개수를 설정합니다.
queryStartingAtValue | 선택한 정렬 기준 메소드에 따라 지정된 키 또는 값보다 크거나 같은 항목을 반환합니다.
queryEndingAtValue | 선택한 정렬 기준 메소드에 따라 지정된 키 또는 값보다 작거나 같은 항목을 반환합니다.
queryEqualToValue | 선택한 정렬 기준 메소드에 따라 지정된 키 또는 값과 동일한 항목을 반환합니다.

 * 실제 queryLimited 메소드만 필드로 나눠지고 나머지는 메소드로 나눠집니다.

사용하기따라 다르겠지만 다중 값에 대한 필터링은 힘듭니다.
제목과 내용에 특정 값을 찾기라던가, 내가 원하는 특정의 뭔가를 임의적으로 하기엔 많이 부족합니다.

그래도 페이징은 이렇게 할수 있습니다

일단 페이징(Pagination 혹은 Paging)에 대해서는 가장 많이 쓰는 부분이기에 예재를 통해서 설명을 드리는 부분이 더 좋을것 같습니다.

```swift
var ref = FIRDatabaseReference! = FIRDatabase.database().reference().child("board")
let rangeOfPosts : UInt = 10    //페이지당 표현 갯수
var pageOfPosts  : UInt = 1     //현재 페이지갯수

var lastestKey : String?        //불러온 가장 마지막 키값

//전체 갯수를 가져온다 (Reload 혹은 최초로딩시
    //)
ref.queryLimited(toFirst: rangeOfPosts * pageOfPosts).observeSingleEvent(of: .value, with: {(snapshot) in
    guard snapshot.exists() else {
        return
    }

    //검색된 값중 가장 마지막 키갑
    self.lastestKey = (snapshot.children.allObjects.last as! FIRDataSnapshot).key

    //코드 생략
}

//마지막 키값기준의 10개씩 가지고 온다.
ref.queryStarting(atValue: lastestKey).queryLimited(toFirst: rangeOfPosts).observeSingleEvent(of: .value, with: {(snapshot) in
    guard snapshot.exists() else {
        return
    }

    //검색된 값중 가장 마지막 키갑
    self.lastestKey = (snapshot.children.allObjects.last as! FIRDataSnapshot).key

    //코드 생략
}

```

위의 코드를 설명을 붙이자면 ```swift var lastestKey : String? ``` 부분은 검색된 부분의 가장 마지막 값입니다. 왜 이렇게 사용을 하는가 싶겠지만...사실 파베는 저희들이 원하는 것을 정확하게 뽑아내기는 힘듭니다. 

예를 들자면 이곳 저곳의 데이터를 동시에 뽑아낼수가 없고 특정 범위중에서 만족하는 값(=교집합)을 뽑아 낼수 없습니다. 단순히 범위까지는 뽑아냅니다 toLast toFirst 등의 옵션으로 말이죠

그럼 어떻게 해야 하나? 방법은 자체적으로 sort를 하는수 밖에 없습니다. 
그나마 페이징은 조금 나은 편입니다. 위의 방법으로 원하는 갯수를 뽑아 낼수 있으니까요

NoSQL 문서타입의 특성때문에 상황에 따른 적절한 검색이 좀 힘듭니다. 
그냥 값을 가져와서 자체적으로 검색할수 있게 만드는것이 더 편하게 코딩하는 방법일껍니다.


실시간데이터베이스에 관한 내용은 이걸로 마치려고 합니다.
기존의 구글설명이 잘나와 있기도 한 이유가 있지만 파베의 실시간데이터베이스를 이해하는데
조금은 도움이 되었으면 하기에 작성한 글입니다.

사진도 없고 코드와 글뿐이지만 도움이 되셨으면 좋겠습니다.

궁금하신점은 댓글 남겨주시면 도와 드리겠습니다. 







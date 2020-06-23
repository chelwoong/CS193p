# CHAPTER1

- didSet
- Outlet/Action/Outlet Collection
- Optional

#### Reading Homework
- [Optionals](#optionals)


## Optionals
옵셔널은 값이 없을 수도 있는 상황에서 사용한다. 옵셔널은 값이 있지만 unwrap 해서 값에 접근해야 하는 경우와 값이 없는 두 가지 상황이 있다.
> NOTE  
optionals이란 개념은 C나 Objective-C 에는 없는 개념이다. 
Objective-C에서 비슷한 개념을 찾으면 메소드에서 원래는 object를 리턴해야 하는 경우에 값이 없이 nil을 리턴하는 경우인데 
이건 오직 objects에 대해서만 가능하지 structures 나 기본 C타입, 열거형(enumeration)에는 없는 개념이다.
값이 없어 nil을 리턴하기 위해서 Objective-C에서는 NSNotFound라는 특별한 값을 리턴한다.
이런 접근방식에서는 메서드를 호출할 때 값이 없을 경우를 예상하고 기억했다가 체크해야한다. 
Swift에서 옵셔널은 NSNotFound같은 특별한 상수 없이도 어떤 타입에서든 값이 없음을 나타낼 수 있다.

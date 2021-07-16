import RxSwift
import RxRelay

public extension ObserverType {
    func onComplete() {
        self.onCompleted()
    }
}

public typealias Observables<T> = Observable<T>
public extension Observable {

    func flatMapNR<Destination>(_ conversion: @escaping (Element)->Observable<Destination>) -> Observable<Destination> {
        return self.flatMap { (it: Element) -> Observable<Destination> in
            conversion(it)
        }
    }

    func switchMap<Destination>(_ conversion: @escaping (Element) -> Observable<Destination>) -> Observable<Destination> {
        return self.flatMapLatest { (it: Element) -> Observable<Destination> in
            conversion(it)
        }
    }

    func drop(_ count: Int) -> Observable<Element> {
        return self.skip(count)
    }


    func subscribeBy(onError: ((Swift.Error) -> Void)? = nil, onComplete: (() -> Void)? = nil, onNext: ((Element) -> Void)? = nil) -> Disposable {
        return subscribe(onNext: onNext, onError: onError, onCompleted: onComplete, onDisposed: nil)
    }
    func subscribeBy(_ onError: ((Swift.Error) -> Void)? = nil, _ onComplete: (() -> Void)? = nil, _ onNext: ((Element) -> Void)? = nil) -> Disposable {
        return subscribe(onNext: onNext, onError: onError, onCompleted: onComplete, onDisposed: nil)
    }
    func subscribe(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    func subscribeBy(_ onNext: ((Element) -> Void)? = nil) -> Disposable {
        return subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    func doOnComplete(_ action: @escaping () throws -> Void) -> Observable<Element> {
        return self.do(onCompleted: action)
    }
    func doOnError(_ action: @escaping (Error) throws -> Void) -> Observable<Element> {
        return self.do(onError: action)
    }
    func doOnNext(_ action: @escaping (Element) throws -> Void) -> Observable<Element> {
        return self.do(onNext: action)
    }
    func doOnTerminate(_ action: @escaping () -> Void) -> Observable<Element> {
        return self.do(onDispose: action)
    }

    func doOnSubscribe(_ action: @escaping (Disposable) -> Void) -> Observable<Element> {
        return self.do(onSubscribe: { action(placeholderDisposable) })
    }
    func doOnDispose(_ action: @escaping () -> Void) -> Observable<Element> {
        return self.do(onDispose: action)
    }


    static func create(_ action: @escaping (ObservableEmitter<Element>) -> Void) -> Observable<Element> {
        return Observable.create { (it: AnyObserver<Element>) in
            let emitter = ObservableEmitter(basedOn: it)
            action(emitter)
            return emitter.disposable ?? Disposables.create { }
        }
    }

    static func just(_ items: Element...) -> Observable<Element> {
        return Observable<Element>.from(items)
    }



}

public class ObservableEmitter<Element>: ObserverType {
    public func on(_ event: RxSwift.Event<Element>) {
        basedOn.on(event)
    }

    public var basedOn: AnyObserver<Element>
    public init(basedOn: AnyObserver<Element>) {
        self.basedOn = basedOn
    }

    public var disposable: Disposable? = nil
    public func setDisposable(_ disposable: Disposable?) {
        self.disposable = disposable
    }
    public var isDisposed: Bool = false
}

public typealias Subject<T> = Observable<T>
public extension Subject {

    func tryObserver() -> AnyObserver<Element>? {
        if let thing = self as? PublishSubject {
            return thing.asObserver()
        }
        if let thing = self as? BehaviorSubject {
            return thing.asObserver()
        }
        if let thing = self as? AsyncSubject {
            return thing.asObserver()
        }
        if let thing = self as? ReplaySubject {
            return thing.asObserver()
        }
        return nil
    }

    func onNext(_ element: Element) {
        tryObserver()?.onNext(element)
    }
    func onNext(value: Element) -> Void {
        return onNext(value)
    }

    func onError(error: Error) -> Void {
        return onError(error)
    }
    func onError(_ error: Error) {
        tryObserver()?.onError(error)
    }

    func onCompleted() {
        tryObserver()?.onCompleted()
    }

}

private let placeholderDisposable = DisposableLambda {}

public extension PrimitiveSequenceType where Trait == SingleTrait {


    func toObservable() -> Observable<Element> {
        return self.primitiveSequence.asObservable()
    }

    func subscribeBy(_ onError: ((Error) -> Void)? = nil, _ onSuccess: ((Element) -> Void)? = nil) -> Disposable {
        return self.subscribe(onSuccess: onSuccess, onError: onError)
    }
    func subscribeBy(onError: @escaping (Error) -> Void, onSuccess: @escaping (Element) -> Void) -> Disposable {
        return subscribeBy(onError, onSuccess)
    }

    func cache() -> Single<Self.Element> {
        return self.toObservable().share(replay: 1, scope: .forever).asSingle()
    }

    func doOnSubscribe(_ action: @escaping (Disposable) -> Void) -> Single<Element> {
        return self.do(onSubscribe: { action(placeholderDisposable) })
    }

    func doFinally(_ action: @escaping () -> Void) -> Single<Element> {
        return self.do(onSuccess: { _ in action() }, onError: { _ in action() })
    }

    func doOnSuccess(_ action: @escaping (Element) -> Void) -> Single<Element> {
        return self.do(onSuccess: action)
    }

    func doOnError(_ action: @escaping (Swift.Error) -> Void) -> Single<Element> {
        return self.do(onError: action)
    }


    static func create(_ action: @escaping (SingleEmitter<Element>) -> Void) -> Single<Element> {
        return Single.create { (callback) -> Disposable in
            let emitter = SingleEmitter<Element>(basedOn: callback)
            action(emitter)
            return emitter.disposable ?? Disposables.create { }
        }
    }


}

public class SingleEmitter<Element> {
    public func on(_ event: RxSwift.SingleEvent<Element>) {
        basedOn(event)
    }
    public func onSuccess(_ element: Element) {
        basedOn(.success(element))
    }
    public func onError(_ error: Error) {
        basedOn(.error(error))
    }

    public var basedOn: (RxSwift.SingleEvent<Element>)->Void
    public init(basedOn: @escaping (RxSwift.SingleEvent<Element>)->Void) {
        self.basedOn = basedOn
    }

    public var disposable: Disposable? = nil
    public func setDisposable(_ disposable: Disposable?) {
        self.disposable = disposable
    }
    public var isDisposed: Bool = false
}

public typealias Scheduler = RxSwift.SchedulerType

public enum Schedulers {

    public static func newThread() -> Scheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }

    public static func io() -> Scheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }

}

public enum AndroidSchedulers {

    public static func mainThread() -> Scheduler {
        return MainScheduler.instance
    }

}

public extension BehaviorSubject {
    static func create(value: Element) -> BehaviorSubject<Element> {
        return BehaviorSubject(value: value)
    }
}
public extension PublishSubject {
    static func create() -> PublishSubject<Element> {
        return PublishSubject()
    }
}

extension Observable {
    public func distinct<T: Hashable>(_ by: @escaping (Element)->T) -> Observable<Element> {
         var cache = Set<T>()
         return flatMap { element -> Observable<Element> in
             if cache.contains(by(element)) {
                 return Observable<Element>.empty()
             } else {
                 cache.insert(by(element))
                 return Observable<Element>.just(element)
             }
         }
     }
}

extension Observable where Element: Hashable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
     public func distinct() -> Observable<Element> {
         var cache = Set<Element>()
         return flatMap { element -> Observable<Element> in
             if cache.contains(element) {
                 return Observable<Element>.empty()
             } else {
                 cache.insert(element)
                 return Observable<Element>.just(element)
             }
         }
     }
}

extension Observable where Element: Equatable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = [Element]()
        return flatMap { element -> Observable<Element> in
            if cache.contains(element) {
                return Observable<Element>.empty()
            } else {
                cache.append(element)
                return Observable<Element>.just(element)
            }
        }
    }
}

extension ObservableType {
    /**
    Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.
    - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)
    - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
    - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
    */
    public func combineLatest<O2: ObservableType, OUT>
        (observable: O2, function: @escaping (Element, O2.Element) throws -> OUT)
            -> Observable<OUT> {
                return Observable<OUT>.combineLatest(self, observable, resultSelector: function)
    }
    public func combineLatest<O2: ObservableType, OUT>
        (_ observable: O2, _ function: @escaping (Element, O2.Element) throws -> OUT)
            -> Observable<OUT> {
                return Observable<OUT>.combineLatest(self, observable, resultSelector: function)
    }
}

extension Observable where Observable.Element: OptionalConvertible {
    func filterNotNull() -> Observable<Element.Wrapped> {
        self.filter { $0.asOptional != nil }.map { $0.asOptional! }
    }
}

func xListCombineLatest<IN, OUT>(
    _ self: Array<Observable<IN>>,
    combine: @escaping (Array<IN>) -> OUT
) -> Observable<OUT> {
    return Observable.combineLatest(self, resultSelector: combine)
}
func xListCombineLatest<IN>(
    _ self: Array<Observable<IN>>
) -> Observable<Array<IN>> {
    return Observable.combineLatest(self)
}
extension Array where Element: ObservableType {
    func combineLatest<OUT>(combine: @escaping (Array<Element.Element>)->OUT) -> Observable<OUT> {
        return Observable.combineLatest(self, resultSelector: combine)
    }
    func combineLatest() -> Observable<Array<Element.Element>> {
        return Observable.combineLatest(self)
    }
    func combineLatest() -> Observable<Array<Element.Element>> {
        return Observable.combineLatest(self)
    }
}

public extension Observable {
    func mapNotNull<Destination>(_ transform: @escaping (Element) -> Destination?) -> Observable<Destination> {
        return mapNotNull(transform: transform)
    }
    func mapNotNull<Destination>(transform: @escaping (Element) -> Destination?) -> Observable<Destination> {
        return self.flatMap { (it: Element) -> Observable<Destination> in
            if let result: Destination = transform(it) {
                return Observable<Destination>.just(result)
            } else {
                return Observable<Destination>.empty()
            }
        }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    func working(_ observable: MutableObservableProperty<Bool>) -> Single<Element> {
        return self.do(onSuccess: { _ in observable.value = false }, onError: { _ in observable.value = false }, onSubscribe: { observable.value = true })
    }
    func working(observable: MutableObservableProperty<Bool>) -> Single<Element> {
        return working(observable)
    }
}

public extension ConnectableObservableType {
    func autoConnect() -> Observable<E> {
        return Observable.create { observer in
            return self.do(onSubscribe: {
                _ = self.connect()
            }).subscribe { (event: Event<Self.E>) in
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }

            }
        }
    }
}

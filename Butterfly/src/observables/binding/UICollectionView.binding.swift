//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit


//--- RecyclerView.whenScrolledToEnd(()->Unit)
public extension UICollectionView {
    func refreshSizes(){
        post {
            self.retainPositionTargetIndex {
                self.collectionViewLayout.invalidateLayout()
            }
        }
    }
    func refreshData(){
        self.retainPositionTargetIndex {
            self.reloadData()
        }
    }
    func retainPositionTargetIndex(around: ()->Void) {
        guard let centerId = self.indexPathForItem(at: CGPoint(x: self.contentOffset.x + self.frame.midX, y: self.contentOffset.y)) else { around(); return }
        guard let oldCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin else { around(); return }
        let oldScreenY = oldCenterPos.y - self.contentOffset.y
        around()
        while true {
            let newCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin ?? oldCenterPos
            let newScreenY = newCenterPos.y - self.contentOffset.y
            let offset = newScreenY - oldScreenY
            self.contentOffset.y += offset
            self.layoutIfNeeded()
            if abs(offset) < 4 { break }
        }
    }
    func whenScrolledToEnd(action: @escaping () -> Void) -> Void{
        post{
            if let delegate = self.delegate as? HasAtEnd {
                delegate.setAtEnd(action: action)
            } else {
                fatalError("You must give the view a delegate implementing the HasAtEnd protocol first.  You can do so using a 'bind'.")
            }
        }
    }

    //--- RecyclerView.bind(ObservableProperty<List<T>>, T, (ObservableProperty<T>)->UIView)
    private func setupVertical() {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        self.collectionViewLayout = layout
    }
    func bind<T>(data: ObservableProperty<Array<T>>, defaultValue: T, makeView: @escaping (ObservableProperty<T>) -> UIView) -> Void {
        setupVertical()
        post {
            let dg = GeneralCollectionDelegate(
                itemCount: data.value.count,
                getItem: { data.value[$0] },
                makeView: { (obs, _) in makeView(obs) }
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            data.subscribeBy(onNext:  { it in
                dg.itemCount = it.count
                self.refreshData()
            }).until(self.removed)
//            self.setupVertical()
        }
    }


    //--- RecyclerView.bindMulti(ViewControllerAccess, ObservableProperty<List<Any>>, (RVTypeHandler)->Unit)
    func bindMulti(viewDependency: ViewControllerAccess, data: ObservableProperty<Array<Any>>, typeHandlerSetup: (RVTypeHandler) -> Void) -> Void {
        let handler = RVTypeHandler(viewDependency)
        typeHandlerSetup(handler)
        post {
            self.setupVertical()
            
            let dg = GeneralCollectionDelegate(
                itemCount: data.value.count,
                getItem: { data.value[$0] },
                makeView: { (obs, type) in handler.make(type: type, property: obs) },
                getType: { handler.type(item: $0) }
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            data.subscribeBy { it in
                dg.itemCount = it.count
                self.refreshData()
            }.until(self.removed)
        }
    }

    //--- RecyclerView.bindMulti(ObservableProperty<List<T>>, T, (T)->Int, (Int,ObservableProperty<T>)->UIView)
    func bindMulti<T>(data: ObservableProperty<Array<T>>, defaultValue: T, determineType: @escaping (T) -> Int, makeView: @escaping (Int, ObservableProperty<T>) -> UIView) -> Void {
        self.setupVertical()
        post {
            let dg = GeneralCollectionDelegate(
                itemCount: data.value.count,
                getItem: { data.value[$0] },
                makeView: { (obs, type) in makeView(type, obs) },
                getType: determineType
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            data.subscribeBy { it in
                dg.itemCount = it.count
                self.refreshData()
            }.until(self.removed)
        }
    }

    //--- RecyclerView.bindRefresh(ObservableProperty<Boolean>, ()->Unit)
    func bindRefresh(loading: ObservableProperty<Bool>, refresh: @escaping () -> Void) -> Void {
        let control = UIRefreshControl()
        control.addAction(for: .valueChanged, action: refresh)
        if #available(iOS 10.0, *) {
            refreshControl = control
        } else {
            addSubview(control)
        }
        loading.subscribeBy { (value) in
            if value {
                control.beginRefreshing()
            } else {
                control.endRefreshing()
            }
        }.until(control.removed)
    }
}


//--- RVTypeHandler.{

public class RVTypeHandler {

    public var viewDependency: ViewControllerAccess

    //--- RVTypeHandler.Primary Constructor
    public init(viewDependency: ViewControllerAccess) {
        self.viewDependency = viewDependency
        let typeCount: Int = 0
        self.typeCount = typeCount
        let handlers: Array<Handler> = Array<Handler>()
        self.handlers = handlers
        let defaultHandler: Handler = Handler(type: Any.self, defaultValue: (), handler: { (obs) in
        newEmptyView(viewDependency)
        })
        self.defaultHandler = defaultHandler
    }
    convenience public init(_ viewDependency: ViewControllerAccess) {
        self.init(viewDependency: viewDependency)
    }

    //--- RVTypeHandler.Handler.{
    public class Handler {

        public var type: Any.Type
        public var defaultValue: Any
        public var handler:  (ObservableProperty<Any>) -> UIView

        //--- RVTypeHandler.Handler.Primary Constructor
        public init(type: Any.Type, defaultValue: Any, handler: @escaping (ObservableProperty<Any>) -> UIView) {
            self.type = type
            self.defaultValue = defaultValue
            self.handler = handler
        }
        convenience public init(_ type: Any.Type, _ defaultValue: Any, _ handler: @escaping (ObservableProperty<Any>) -> UIView) {
            self.init(type: type, defaultValue: defaultValue, handler: handler)
        }

        //--- RVTypeHandler.Handler.}
    }

    var typeCount: Int
    private var handlers: Array<Handler>
    private var defaultHandler: Handler

    //--- RVTypeHandler.handle(KClass<*>, Any,  @escaping()(ObservableProperty<Any>)->UIView)
    public func handle(type: Any.Type, defaultValue: Any, action: @escaping (ObservableProperty<Any>) -> UIView) -> Void {
        handlers.append(Handler(type: type, defaultValue: defaultValue, handler: action))
        typeCount += 1
    }
    public func handle(_ type: Any.Type, _ defaultValue: Any, _ action: @escaping (ObservableProperty<Any>) -> UIView) -> Void {
        return handle(type: type, defaultValue: defaultValue, action: action)
    }

    //--- RVTypeHandler.handle(T,  @escaping()(ObservableProperty<T>)->UIView)
    public func handle<T: Any>(defaultValue: T, action: @escaping (ObservableProperty<T>) -> UIView) -> Void {
        handle(T.self, defaultValue) { (obs) in
            action(obs.map{ (it) in
                it as! T
            })
        }
    }
    public func handle<T: Any>(_ defaultValue: T, _ action: @escaping (ObservableProperty<T>) -> UIView) -> Void {
        return handle(defaultValue: defaultValue, action: action)
    }

    //--- RVTypeHandler Helpers
    func canCast(_ x: Any, toConcreteType destType: Any.Type) -> Bool {
        return sequence(
            first: Mirror(reflecting: x), next: { $0.superclassMirror }
        )
        .contains { $0.subjectType == destType }
    }

    func type(item: Any) -> Int {
        var index = 0
        for handler in handlers{
            if canCast(item, toConcreteType: handler.type) {
                return Int(index)
            }
            index += 1
        }
        return typeCount
    }
    func type(_ item: Any) -> Int {
        return type(item: item)
    }

    func make(type: Int, property: ObservableProperty<Any>) -> UIView {
        var handler = defaultHandler
        if type < typeCount {
            handler = handlers[ type ]
        }
        let subview = handler.handler(property)
        return subview
    }

    //--- RVTypeHandler.}
}

protocol HasAtEnd {
    var atEnd: () -> Void { get set }
    func setAtEnd(action: @escaping () -> Void)
}

class GeneralCollectionDelegate<T>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, HasAtEnd {
    var atEnd: () -> Void = {}
    
    func setAtEnd(action: @escaping () -> Void) {
        self.atEnd = action
    }
    
    var itemCount: Int
    let getItem: (Int) -> T
    let makeView: (ObservableProperty<T>, Int) -> UIView
    let getType: (T) -> Int
    var atPosition: (Int) -> Void = { _ in }
    
    init(
        itemCount: Int = 0,
        getItem: @escaping (Int) -> T,
        makeView: @escaping (ObservableProperty<T>, Int) -> UIView,
        getType: @escaping (T) -> Int = { _ in 0 },
        atPosition: @escaping (Int) -> Void = { _ in }
    ) {
        self.itemCount = itemCount
        self.getItem = getItem
        self.makeView = makeView
        self.getType = getType
        self.atPosition = atPosition
    }
    
    private var registered: Set<Int> = []
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = getItem(indexPath.row)
        let type = getType(item)
        if registered.insert(type).inserted {
            collectionView.register(ObsUICollectionViewCell.self, forCellWithReuseIdentifier: String(type))
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(type), for: indexPath) as! ObsUICollectionViewCell
        if collectionView.reverseDirection {
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        } else {
            cell.contentView.transform = .identity
        }
        cell.setNeedsDisplay()
        
        if cell.obs == nil {
            let obs = StandardObservableProperty<T>(underlyingValue: item)
            let newView = makeView(obs, type)
            cell.contentView.addSubview(newView)
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            newView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            newView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            newView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor).isActive = true
            newView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor).isActive = true
            cell.obs = obs
        }
        if let obs = cell.obs as? MutableObservableProperty<T> {
            obs.value = item
        } else {
            fatalError("Could not find cell property")
        }
        post {
            cell.refreshLifecycle()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row >= itemCount - 1 && itemCount > 1){
            print("Triggered end with \(indexPath.row) size \(itemCount)")
            atEnd()
        }
        if let cell = cell as? ObsUICollectionViewCell {
            cell.resizeEnabled = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? ObsUICollectionViewCell {
            cell.resizeEnabled = false
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        if let x = collectionView.currentIndex {
            atPosition(Int(x))
        }
    }
}

class ObsUICollectionViewCell: UICollectionViewCell {
    var obs: Any?
    var resizeEnabled = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.clipsToBounds = true
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override var transform: CGAffineTransform {
        get {
            return super.transform
        }
        set(value){
            super.transform = value
        }
    }

}

class SizedUICollectionViewCell: ObsUICollectionViewCell {
    var isVertical = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.clipsToBounds = true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        for child in contentView.subviews {
            child.translatesAutoresizingMaskIntoConstraints = true
            child.frame = contentView.bounds
            child.layoutSubviews()
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var outSize = CGSize.zero
        layoutIfNeeded()
        for child in contentView.subviews {
            let childSize = child.sizeThatFits(size)
            outSize.width = max(outSize.width, childSize.width)
            outSize.height = max(outSize.height, childSize.height)
        }
        outSize.width = max(outSize.width, 20)
        outSize.height = max(outSize.height, 20)
        if isVertical {
            outSize.width = size.width
        } else {
            outSize.height = size.height
        }
        return outSize
    }
    public func refreshSize() {
        guard resizeEnabled else { return }
        var current = self.superview
        while current != nil && !(current is UICollectionView) {
            current = current?.superview
        }
        if let current = current as? UICollectionView {
            if let dataSource = current.dataSource,
                dataSource.collectionView(current, numberOfItemsInSection: 0) == current.numberOfItems(inSection: 0)
            {
//                UIView.performWithoutAnimation {
                    current.performBatchUpdates({}, completion: nil)
//                }
            } else {
                current.reloadData()
            }
        }
    }
}

public extension UICollectionView {
    
    //--- RecyclerView.reverseDirection
    static let extensionReverse = ExtensionProperty<UICollectionView, Bool>()
    
    @objc
    var reverseDirection: Bool {
        get {
            return UICollectionView.extensionReverse.get(self) ?? false
        }
        set(value) {
            UICollectionView.extensionReverse.set(self, value)
            let transform = value ? CGAffineTransform(scaleX: 1, y: -1) : .identity
            self.transform = transform
            for cell in self.visibleCells {
                cell.contentView.transform = transform
                cell.setNeedsDisplay()
            }
        }
    }
}

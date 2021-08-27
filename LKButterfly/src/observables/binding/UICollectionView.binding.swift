//Stub file made with Butterfly 2 (by Lightning Kite)
import Foundation
import UIKit

private extension UICollectionViewCompositionalLayout {
    static let fractionalWidthExtension = ExtensionProperty<UICollectionViewCompositionalLayout, CGFloat?>()
    var fractionalWidth: CGFloat? {
        get { return UICollectionViewCompositionalLayout.fractionalWidthExtension.get(self) ?? nil }
        set(value) { UICollectionViewCompositionalLayout.fractionalWidthExtension.set(self, value) }
    }
    static let fractionalHeightExtension = ExtensionProperty<UICollectionViewCompositionalLayout, CGFloat?>()
    var fractionalHeight: CGFloat? {
        get { return UICollectionViewCompositionalLayout.fractionalHeightExtension.get(self) ?? nil }
        set(value) { UICollectionViewCompositionalLayout.fractionalHeightExtension.set(self, value) }
    }
}

internal class FixedLayout: UICollectionViewCompositionalLayout {
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        if let collectionView = collectionView {
            context.invalidateFlowLayoutDelegateMetrics = collectionView.bounds.size != newBounds.size
        }
        return context
    }
}

public class QuickCompositionalLayout {
    public static func list(vertical: Bool = true, reverse: Bool = false) -> UICollectionViewLayout {
        if vertical {
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.estimated(45)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            let result = UICollectionViewCompositionalLayout(section: section)
            result.fractionalWidth = 1
            return result
        } else {
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.estimated(45),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            let result = UICollectionViewCompositionalLayout(section: section)
            result.fractionalHeight = 1
            return result
        }
    }
    public static func grid(orthogonalCount: Int, vertical: Bool = true) -> UICollectionViewLayout {
        if vertical {
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                heightDimension: NSCollectionLayoutDimension.estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: orthogonalCount)
            let section = NSCollectionLayoutSection(group: group)
            let result = UICollectionViewCompositionalLayout(section: section)
            result.fractionalWidth = 1.0/CGFloat(orthogonalCount)
            return result
        } else {
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.estimated(100),
                heightDimension: NSCollectionLayoutDimension.fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: orthogonalCount)
            let section = NSCollectionLayoutSection(group: group)
            let result = UICollectionViewCompositionalLayout(section: section)
            result.fractionalHeight = 1.0/CGFloat(orthogonalCount)
            return result
        }
    }
}

//--- RecyclerView.whenScrolledToEnd(()->Unit)
public extension UICollectionView {
    private static let itemsToReloadSoon = ExtensionProperty<UICollectionView, Set<IndexPath>>()
    private var itemsToReloadSoon: Set<IndexPath> {
        get {
            return UICollectionView.itemsToReloadSoon.get(self) ?? []
        }
        set(value) {
            UICollectionView.itemsToReloadSoon.set(self, value)
        }
    }
    func reloadItemsSoon(_ items: Set<IndexPath>) {
        if itemsToReloadSoon.isEmpty {
            post {
                let itemsToReload = self.itemsToReloadSoon.filter { $0.section < self.numberOfSections && $0.row < self.numberOfItems(inSection: $0.section) }
                print(itemsToReload)
                self.reloadItems(at: Array(itemsToReload))
                self.itemsToReloadSoon = []
            }
        }
        for i in items {
            itemsToReloadSoon.insert(i)
        }
    }
    
    private static let refreshQueued = ExtensionProperty<UICollectionView, Bool>()
    func refreshDataDelayed() {
        if !(UICollectionView.refreshQueued.get(self) ?? false) {
            UICollectionView.refreshQueued.set(self, true)
            post {
                self.refreshData()
                UICollectionView.refreshQueued.set(self, false)
            }
        }
    }
    func refreshData(){
        self.retainPositionTargetIndex {
            self.reloadData()
        }
    }
    
    private static let refreshSizeQueued = ExtensionProperty<UICollectionView, Bool>()
    func refreshSizes() {
        if !(UICollectionView.refreshSizeQueued.get(self) ?? false) {
            UICollectionView.refreshSizeQueued.set(self, true)
            
            guard let centerId = self.indexPathForItem(at: CGPoint(x: self.contentOffset.x + self.frame.midX, y: self.contentOffset.y)) else { return }
            guard let oldCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin else { return }
            let oldScreenY = oldCenterPos.y - self.contentOffset.y
            
            post {
                self.collectionViewLayout.invalidateLayout()
                self.layoutIfNeeded()
                self.collectionViewLayout.invalidateLayout()
                self.layoutIfNeeded()
                var lastDiff: CGFloat = 10000.0
                while true {
                    let newCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin ?? oldCenterPos
                    let newScreenY = newCenterPos.y - self.contentOffset.y
                    let offset = newScreenY - oldScreenY
                    if lastDiff == offset {
                        break
                    }
                    lastDiff = offset
                    self.contentOffset.y += offset
                    self.layoutIfNeeded()
                    if abs(offset) < 4 { break }
                }
                UICollectionView.refreshSizeQueued.set(self, false)
            }
        }
    }
    var padding: UIEdgeInsets {
        get { return contentInset }
        set(value) {
            self.contentInset = value
        }
    }
    func scrollToItemSafe(at: IndexPath, at pos: ScrollPosition = .centeredVertically, animated: Bool = false){
        if at.section >= 0, at.row >= 0, at.section < self.numberOfSections, at.row < self.numberOfItems(inSection: at.section) {
            scrollToItem(at: at, at: pos, animated: animated)
        }
    }
    func retainPositionTargetIndex(around: ()->Void) {
        guard let centerId = self.indexPathForItem(at: CGPoint(x: self.contentOffset.x + self.frame.midX, y: self.contentOffset.y)) else { around(); return }
        guard let oldCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin else { around(); return }
        let oldScreenY = oldCenterPos.y - self.contentOffset.y
        print("Cell \(centerId) was at \(oldScreenY)")
        around()
        while true {
            let newCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin ?? oldCenterPos
            let newScreenY = newCenterPos.y - self.contentOffset.y
            let offset = newScreenY - oldScreenY
            self.contentOffset.y += offset
            self.layoutIfNeeded()
            print("Cell \(centerId) is now at \(newScreenY) after moving \(offset)")
            if abs(offset) < 4 { break }
        }
        post {
            let newCenterPos = self.collectionViewLayout.layoutAttributesForItem(at: centerId)?.frame.origin ?? oldCenterPos
            let newScreenY = newCenterPos.y - self.contentOffset.y
            print("Cell \(centerId) is now at \(newScreenY) after a post")
        }
    }
    static let atEndExtension = ExtensionProperty<UICollectionView, ()->Void>()
    func whenScrolledToEnd(action: @escaping () -> Void) -> Void{
        UICollectionView.atEndExtension.set(self, action)
    }

    //--- RecyclerView.bind(ObservableProperty<List<T>>, T, (ObservableProperty<T>)->UIView)
    private func setupDefault() {
        let current = self.collectionViewLayout
        if current is ReversibleFlowLayout || current is UICollectionViewFlowLayout {
            self.collectionViewLayout = QuickCompositionalLayout.list()
        }
        if let current = current as? UICollectionViewCompositionalLayout {
            current.configuration.interSectionSpacing = max(self.padding.top, self.padding.bottom)
        }
    }
    func bind<T>(data: ObservableProperty<Array<T>>, defaultValue: T, makeView: @escaping (ObservableProperty<T>) -> UIView) -> Void {
        setupDefault()
        post {
            let dg = GeneralCollectionDelegate(
                makeView: { (obs, _) in makeView(obs) }
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            
            var updateQueued = false
            data.subscribeBy(onNext:  { it in
                guard !updateQueued else { return }
                updateQueued = true
                LKButterfly.post {
                    updateQueued = false
                    dg.items = data.value
                    self.refreshData()
                }
            }).until(self.removed)
        }
    }


    //--- RecyclerView.bindMulti(ViewControllerAccess, ObservableProperty<List<Any>>, (RVTypeHandler)->Unit)
    func bindMulti(viewDependency: ViewControllerAccess, data: ObservableProperty<Array<Any>>, typeHandlerSetup: (RVTypeHandler) -> Void) -> Void {
        let handler = RVTypeHandler(viewDependency)
        typeHandlerSetup(handler)
        self.setupDefault()
        post {
            
            let dg = GeneralCollectionDelegate(
                makeView: { (obs, type) in handler.make(type: type, property: obs) },
                getType: { handler.type(item: $0) }
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            var updateQueued = false
            data.subscribeBy(onNext:  { it in
                guard !updateQueued else { return }
                updateQueued = true
                LKButterfly.post {
                    updateQueued = false
                    dg.items = data.value
                    self.refreshData()
                }
            }).until(self.removed)
        }
    }

    //--- RecyclerView.bindMulti(ObservableProperty<List<T>>, T, (T)->Int, (Int,ObservableProperty<T>)->UIView)
    func bindMulti<T>(data: ObservableProperty<Array<T>>, defaultValue: T, determineType: @escaping (T) -> Int, makeView: @escaping (Int, ObservableProperty<T>) -> UIView) -> Void {
        self.setupDefault()
        post {
            let dg = GeneralCollectionDelegate(
                makeView: { (obs, type) in makeView(type, obs) },
                getType: determineType
            )
            self.retain(as: "delegate", item: dg, until: self.removed)
            self.delegate = dg
            self.dataSource = dg
            var updateQueued = false
            data.subscribeBy(onNext:  { it in
                guard !updateQueued else { return }
                updateQueued = true
                LKButterfly.post {
                    updateQueued = false
                    dg.items = data.value
                    self.refreshData()
                }
            }).until(self.removed)
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
        loading.subscribeBy(onNext:  { (value) in
            if value {
                control.beginRefreshing()
            } else {
                control.endRefreshing()
            }
        }).until(control.removed)
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

class GeneralCollectionDelegate<T>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var items: Array<T> = []
    let makeView: (ObservableProperty<T>, Int) -> UIView
    let getType: (T) -> Int
    var atPosition: (Int) -> Void = { _ in }

    init(
        makeView: @escaping (ObservableProperty<T>, Int) -> UIView,
        getType: @escaping (T) -> Int = { _ in 0 },
        atPosition: @escaping (Int) -> Void = { _ in }
    ) {
        self.makeView = makeView
        self.getType = getType
        self.atPosition = atPosition
    }
    
    private var registered: Set<Int> = []
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let type = getType(item)
        if registered.insert(type).inserted {
            collectionView.register(ObsUICollectionViewCell.self, forCellWithReuseIdentifier: String(type))
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(type), for: indexPath) as! ObsUICollectionViewCell
        cell.indexPath = indexPath
        cell.resizeEnabled = false
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
            cell.obs = obs
        }
        if let obs = cell.obs as? MutableObservableProperty<T> {
            obs.value = item
        } else {
            fatalError("Could not find cell property")
        }
        cell.absorbCaps(collectionView: collectionView)
        cell.setNeedsLayout()
        cell.resizeEnabled = true
        post {
            cell.refreshLifecycle()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row >= items.count - 1 && items.count > 1){
            print("Triggered end with \(indexPath.row) size \(items.count)")
            if let atEnd = UICollectionView.atEndExtension.get(collectionView) {
                atEnd()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let cell = cell as? ObsUICollectionViewCell {
            cell.indexPath = nil
            post {
                cell.refreshLifecycle()
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        if let x = collectionView.currentIndex {
            atPosition(Int(x))
        }
    }
}

class ObsUICollectionViewCell: UICollectionViewCell, ListensToChildSize {
    
    weak var collectionView: UICollectionView?
    var obs: Any?
    var resizeEnabled = false
    var indexPath: IndexPath? = nil
    
    var heightSetSize: CGFloat? = nil
    var widthSetSize: CGFloat? = nil
    
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
    }
    
    override func layoutSubviews() {
        contentView.frame = self.bounds
        for child in contentView.subviews {
            child.frame = contentView.bounds
        }
    }
    
    func absorbCaps(collectionView: UICollectionView){
        self.collectionView = collectionView
        if let layout = collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout {
            if let s = layout.fractionalWidth {
                widthSetSize = collectionView.frame.size.width * s
            }
            if let s = layout.fractionalHeight {
                heightSetSize = collectionView.frame.size.height * s
            }
        }
    }
    
    var lastSize: CGSize = .zero
    private func internalMeasure(_ targetSize: CGSize) -> CGSize {
        var newTargetSize = targetSize
        if let widthSetSize = widthSetSize {
            newTargetSize.width = widthSetSize
        }
        if let heightSetSize = heightSetSize {
            newTargetSize.height = heightSetSize
        }
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        for child in contentView.subviews {
            let childSize = child.systemLayoutSizeFitting(newTargetSize)
            if childSize.width > maxX { maxX = childSize.width }
            if childSize.height > maxY { maxY = childSize.height }
        }
        return CGSize(width: maxX, height: maxY)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let newSize = internalMeasure(targetSize)
        lastSize = newSize
        return newSize
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return systemLayoutSizeFitting(size)
    }
    override var intrinsicContentSize: CGSize {
        return systemLayoutSizeFitting(CGSize.zero)
    }
    
    func childSizeUpdated(_ child: UIView) {
        guard resizeEnabled, lastSize != internalMeasure(.zero) else { return }
        self.setNeedsLayout()
        if let collectionView = collectionView {
            if self.indexPath != nil {
                collectionView.refreshSizes()
            }
        }
    }
    
    deinit {
        self.removedDeinitHandler()
    }
}

public extension UICollectionView {
    
    class ReversibleFlowLayout: UICollectionViewFlowLayout {}
    
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

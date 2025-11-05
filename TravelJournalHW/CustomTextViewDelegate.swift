protocol CustomTextViewDelegate: AnyObject {
    
    func titleDidChange(text: String)
    
    func bodyDidChange(text: String)
}
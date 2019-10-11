import UIKit

class GameTableViewCell1 : UITableViewCell{
    
    var NameLabel : UILabel?
    
    var SpeechView : ZFJVoiceBubble?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.NameLabel = UILabel()
        self.addSubview(NameLabel!)
        
        self.SpeechView = ZFJVoiceBubble.init()
        self.addSubview(SpeechView!)

        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.NameLabel?.frame = CGRect(x: 10, y: 0, width: 40, height: 30)
        self.NameLabel?.font = UIFont.systemFont(ofSize: 10)
        self.NameLabel?.textColor = UIColor.white
        self.NameLabel?.textAlignment = .left

        self.SpeechView?.frame = CGRect(x: 40, y: 5, width: 100, height: 20)
//        SpeechView?.isShowLeftImg = true
        self.SpeechView?.tag = 99
    }
}


class GameTableViewCell2 : UITableViewCell{
    
    var ReportLabel : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.ReportLabel = UILabel()
        self.addSubview(ReportLabel!)
        
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        self.ReportLabel?.frame = CGRect(x: 10, y: 0, width: 140, height: 30)
        self.ReportLabel?.font = UIFont.systemFont(ofSize: 10)
        self.ReportLabel?.textColor = UIColor.orange
        self.ReportLabel?.numberOfLines = 2
        self.ReportLabel?.lineBreakMode = .byCharWrapping
        
    }
}

class TeamTableViewCell : UITableViewCell,TeamModelDelegate{
    static let identifier = "TeamTableViewCell"
    var model: TeamModel? {
        didSet{
            TeamName?.text = model!.TeamName
            TeamIcon?.kf.setImage(with: URL(string: (model!.TeamIcon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!), placeholder: UIImage(named: "logo.png"))
            TeamBlood?.frame.size.width = CGFloat(model!.TeamBlood*160/100)
            TeamDyingBlood?.frame.size.width = CGFloat(model!.TeamDyingBlood*160/100)
            TeamArmor?.frame.size.width = CGFloat(model!.TeamArmor*135/100)
            TeamBlood_2?.frame.size.width = CGFloat(model!.TeamBlood*160/100)
            TeamDyingBlood_2?.frame.size.width = CGFloat(model!.TeamDyingBlood*160/100)
            TeamArmor_2?.frame.size.width = CGFloat(model!.TeamArmor*135/100)
            TeamState = model!.TeamState
            TeamKillView?.text = "击杀：\(model!.TeamKill)"
            TeamDamageView?.text = "伤害：\(model!.TeamDamage)"
            myState = model!.myState
            model?.delegate = self
        }
    }
    var TeamIconView : UIImageView?
    var TeamIcon : UIImageView?
    var TeamView : UIImageView?
    var TeamName : UILabel?
    var TeamDead : UILabel?
    var TeamBloodView : UIView?
    var TeamBlood_2 : UIImageView?
    var TeamBlood : UIImageView?
    var TeamDyingBlood_2 : UIImageView?
    var TeamDyingBlood : UIImageView?
    var TeamArmorView : UIView?
    var TeamArmor_2 : UIImageView?
    var TeamArmor : UIImageView?
    var TeamKillView : UILabel?
    var TeamDamageView : UILabel?
    var saveButton : UIButton?
    var TeamState : Int?
    var myState : Int?
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.TeamIconView = UIImageView()
        self.addSubview(TeamIconView!)
        
        self.TeamIcon = UIImageView()
        self.TeamIconView?.addSubview(TeamIcon!)
        
        self.TeamView = UIImageView()
        self.addSubview(TeamView!)
        
        self.TeamName = UILabel()
        self.TeamView?.addSubview(TeamName!)

        self.TeamDead = UILabel()
        self.TeamView?.addSubview(TeamDead!)
        
        self.TeamBloodView = UIView()
        self.TeamView?.addSubview(TeamBloodView!)
        
        self.TeamBlood_2 = UIImageView()
        self.TeamBloodView?.addSubview(TeamBlood_2!)
        
        self.TeamBlood = UIImageView()
        self.TeamBloodView?.addSubview(TeamBlood!)
        
        self.TeamDyingBlood_2 = UIImageView()
        self.TeamBloodView?.addSubview(TeamDyingBlood_2!)
        
        self.TeamDyingBlood = UIImageView()
        self.TeamBloodView?.addSubview(TeamDyingBlood!)
        
        self.TeamArmorView = UIView()
        self.TeamView?.addSubview(TeamArmorView!)
        
        self.TeamArmor_2 = UIImageView()
        self.TeamArmorView?.addSubview(TeamArmor_2!)
        
        self.TeamArmor = UIImageView()
        self.TeamArmorView?.addSubview(TeamArmor!)
        
        self.TeamKillView = UILabel()
        self.addSubview(TeamKillView!)
        
        self.TeamDamageView = UILabel()
        self.addSubview(TeamDamageView!)
        
        self.saveButton = UIButton()
        self.addSubview(saveButton!)
        
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model?.delegate = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        self.TeamIconView?.frame = CGRect(x: 0, y: 5, width: 34, height: 34)
        self.TeamIconView?.image = UIImage(named: "headbg.png")
        self.TeamIconView?.isHidden = true
        
        self.TeamIcon?.frame = CGRect(x: 3, y: 2.5, width: 28, height: 28)
        self.TeamIcon?.layer.cornerRadius = (TeamIcon?.frame.width)!/2
        self.TeamIcon?.layer.masksToBounds = true
        self.TeamIcon?.contentMode = .scaleAspectFill
        
        self.TeamView?.frame = CGRect(x: 0, y: 5, width: 170, height: 34)
        self.TeamView?.image = UIImage(named: "teamview.png")
        
        self.TeamName?.frame = CGRect(x: 50, y: 0, width: 80, height: 10)
        self.TeamName?.font = UIFont.systemFont(ofSize: 9)
        self.TeamName?.textColor = UIColor.orange
        self.TeamName?.textAlignment = .left
        
        self.TeamDead?.frame = CGRect(x: 120, y: 0, width: 50, height: 10)
        self.TeamDead?.font = UIFont.systemFont(ofSize: 9)
        self.TeamDead?.textColor = UIColor.red
        self.TeamDead?.textAlignment = .left
        self.TeamDead?.text = "(淘汰)"
        self.TeamDead?.isHidden = true
        
        self.TeamBloodView?.frame = CGRect(x: 7, y: 13, width: 160, height: 6)
        self.TeamBloodView?.backgroundColor = UIColor.clear
        
        self.TeamBlood_2?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        self.TeamBlood_2?.image = UIImage(named: "teamblood_2.png")
        self.TeamBlood_2?.contentMode = .left
        self.TeamBlood_2?.clipsToBounds = true
        
        self.TeamBlood?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        animation(ImageName: "teamblood", ImageView: self.TeamBlood!)
        self.TeamBlood?.contentMode = .left
        self.TeamBlood?.clipsToBounds = true
        
        self.TeamDyingBlood_2?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        self.TeamDyingBlood_2?.image = UIImage(named: "teamdyingblood_2.png")
        self.TeamDyingBlood_2?.contentMode = .left
        self.TeamDyingBlood_2?.clipsToBounds = true
        self.TeamDyingBlood_2?.isHidden = true
        
        self.TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        animation(ImageName: "teamdyingblood", ImageView: self.TeamDyingBlood!)
        self.TeamDyingBlood?.contentMode = .left
        self.TeamDyingBlood?.clipsToBounds = true
        self.TeamDyingBlood?.isHidden = true
        
        self.TeamArmorView?.frame = CGRect(x: 31, y: 22, width: 135, height: 6)
        self.TeamArmorView?.backgroundColor = UIColor.clear
        
        self.TeamArmor_2?.frame = CGRect(x: 0, y: 0, width: 135, height: 6)
        self.TeamArmor_2?.image = UIImage(named: "teamarmor_2.png")
        self.TeamArmor_2?.contentMode = .left
        self.TeamArmor_2?.clipsToBounds = true
        
        self.TeamArmor?.frame = CGRect(x: 0, y: 0, width: 135, height: 6)
        animation(ImageName: "teamarmor", ImageView: self.TeamArmor!)
        self.TeamArmor?.contentMode = .left
        self.TeamArmor?.clipsToBounds = true
        
        self.TeamKillView?.frame = CGRect(x: 40, y: 40, width: 70, height: 10)
        self.TeamKillView?.font = UIFont.systemFont(ofSize: 9)
        self.TeamKillView?.textColor = UIColor.orange
        self.TeamKillView?.textAlignment = .left
        self.TeamKillView?.isHidden = true
        
        self.TeamDamageView?.frame = CGRect(x: 110, y: 40, width: 70, height: 10)
        self.TeamDamageView?.font = UIFont.systemFont(ofSize: 9)
        self.TeamDamageView?.textColor = UIColor.orange
        self.TeamDamageView?.textAlignment = .left
        self.TeamDamageView?.isHidden = true
        
        self.saveButton?.frame = CGRect(x: 175, y: 15, width: 40, height: 20)
        self.saveButton?.setBackgroundImage(UIImage(named: "savebtn.png"), for: .normal)
        self.saveButton?.isHidden = true
        
    }
    
    func didUpdate(Model: TeamModel) {
        TeamState = Model.TeamState
        myState = Model.myState
        if TeamState == 1{   //正常
            TeamBlood?.isHidden = false
            TeamBlood_2?.isHidden = false
            TeamDyingBlood?.isHidden = true
            TeamDyingBlood_2?.isHidden = true
            TeamDead?.isHidden = true
            saveButton?.isHidden = true
        }
        else if TeamState == 3{   //濒死
            TeamBlood?.isHidden = true
            TeamBlood_2?.isHidden = true
            TeamDyingBlood?.isHidden = false
            TeamDyingBlood_2?.isHidden = false
            TeamDead?.isHidden = true
            if myState == 1 {
                saveButton?.isHidden = false
            }else{
                saveButton?.isHidden = true
            }
        }
        else if TeamState == 2{   //死亡
            TeamDead?.isHidden = false
            saveButton?.isHidden = true
        }
        TeamName?.text = Model.TeamName
        TeamIcon?.kf.setImage(with: URL(string: (Model.TeamIcon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)), placeholder: UIImage(named: "logo.png"))
        TeamBlood?.frame.size.width = CGFloat(Model.TeamBlood*160/100)
        TeamDyingBlood?.frame.size.width = CGFloat(Model.TeamDyingBlood*160/100)
        TeamArmor?.frame.size.width = CGFloat(Model.TeamArmor*135/100)
        UIView.animate(withDuration: 0.3, animations: {
            self.TeamBlood_2?.frame.size.width = CGFloat(Model.TeamBlood*160/100)
            self.TeamDyingBlood_2?.frame.size.width = CGFloat(Model.TeamDyingBlood*160/100)
            self.TeamArmor_2?.frame.size.width = CGFloat(Model.TeamArmor*135/100)
        })
        TeamKillView?.text = "击杀：\(Model.TeamKill)"
        TeamDamageView?.text = "伤害：\(Model.TeamDamage)"
    }
    
}

class BagTableViewCell : UITableViewCell{
    static let identifier = "BagTableViewCell"

    var itemView : UIView?
    
    var itemImage : UIImageView?
    
    var itemName : UILabel?
    
    var itemNum : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.itemView = UIView()
        self.addSubview(itemView!)
        
        self.itemImage = UIImageView()
        self.itemView?.addSubview(itemImage!)
        
        self.itemName = UILabel()
        self.itemView?.addSubview(itemName!)
        
        self.itemNum = UILabel()
        self.itemView?.addSubview(itemNum!)
        
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.itemView?.frame = CGRect(x: 0, y: 0, width: 130, height: 60)
        self.itemView?.backgroundColor = UIColor(patternImage: UIImage(named: "itembg.png")!)
        
        self.itemImage?.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
        self.itemImage?.contentMode = .scaleAspectFill
        
        self.itemName?.frame = CGRect(x: 70, y: 5, width: 60, height: 20)
        self.itemName?.textColor = UIColor.white
        self.itemName?.textAlignment = .left
        self.itemName?.font = UIFont.systemFont(ofSize: 9)
        
        self.itemNum?.frame = CGRect(x: 70, y: 25, width: 60, height: 20)
        self.itemNum?.textColor = UIColor.white
        self.itemNum?.textAlignment = .left
        self.itemNum?.font = UIFont.systemFont(ofSize: 9)

    }
}

class NearTableViewCell : UITableViewCell{
    static let identifier = "NearTableViewCell"
    
    var itemView : UIView?
    
    var itemImage : UIImageView?
    
    var itemName : UILabel?
    
    var itemNum : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.itemView = UIView()
        self.addSubview(itemView!)
        
        self.itemImage = UIImageView()
        self.itemView?.addSubview(itemImage!)
        
        self.itemName = UILabel()
        self.itemView?.addSubview(itemName!)
        
        self.itemNum = UILabel()
        self.itemView?.addSubview(itemNum!)
        
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.itemView?.frame = CGRect(x: 0, y: 0, width: 130, height: 60)
        self.itemView?.backgroundColor = UIColor(patternImage: UIImage(named: "itembg.png")!)
        
        self.itemImage?.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
//        self.itemImage?.contentMode = .scaleAspectFill
        
        self.itemName?.frame = CGRect(x: 70, y: 5, width: 60, height: 20)
        self.itemName?.textColor = UIColor.white
        self.itemName?.textAlignment = .left
        self.itemName?.font = UIFont.systemFont(ofSize: 9)
        
        self.itemNum?.frame = CGRect(x: 70, y: 25, width: 60, height: 20)
        self.itemNum?.textColor = UIColor.white
        self.itemNum?.textAlignment = .left
        self.itemNum?.font = UIFont.systemFont(ofSize: 9)
    }
}

class battleResultsTableViewCell : UITableViewCell{
    
    var IconView : UIImageView?
    
    var Icon : UIImageView?
    
    var Name : UILabel?
    
    var Damage : UILabel?
    
    var Kill : UILabel?
    
    var Survival : UILabel?
    
    var dead : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.IconView = UIImageView()
        self.addSubview(IconView!)
        
        self.Icon = UIImageView()
        self.IconView?.addSubview(Icon!)
        
        self.Name = UILabel()
        self.addSubview(Name!)
        
        self.Damage = UILabel()
        self.addSubview(Damage!)
        
        self.Kill = UILabel()
        self.addSubview(Kill!)
        
        self.Survival = UILabel()
        self.addSubview(Survival!)
        
        self.dead = UILabel()
        self.addSubview(dead!)
        
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        self.IconView?.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        self.IconView?.image = UIImage(named: "zhanbao_head.png")
        self.IconView?.contentMode = .scaleAspectFill
        
        self.Icon?.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.Icon?.layer.cornerRadius = (self.Icon?.frame.width)!/2
        self.Icon?.layer.masksToBounds = true
        self.Icon?.contentMode = .scaleAspectFill
        
        self.Name?.frame = CGRect(x: 45, y: 13, width: 80, height: 20)
        self.Name?.textColor = UIColor.white
        self.Name?.font = UIFont.systemFont(ofSize: 14)
        self.Name?.textAlignment = .center
        
        self.Damage?.frame = CGRect(x: 155, y: 13, width: 80, height: 20)
        self.Damage?.textColor = UIColor.white
        self.Damage?.font = UIFont.systemFont(ofSize: 14)
        self.Damage?.textAlignment = .center
        
        self.Kill?.frame = CGRect(x: 280, y: 13, width: 80, height: 20)
        self.Kill?.textColor = UIColor.white
        self.Kill?.font = UIFont.systemFont(ofSize: 14)
        self.Kill?.textAlignment = .center
        
        self.Survival?.frame = CGRect(x: 415, y: 13, width: 80, height: 20)
        self.Survival?.textColor = UIColor.white
        self.Survival?.font = UIFont.systemFont(ofSize: 14)
        self.Survival?.textAlignment = .center
        
        self.dead?.frame = CGRect(x: 415, y: 13, width: 80, height: 20)
        self.dead?.textColor = UIColor.white
        self.dead?.font = UIFont.systemFont(ofSize: 14)
        self.dead?.textAlignment = .center
    }
}

//
//  QDRAboutUsViewController.m
//  freeBook
//
//  Created by 杨兆欣 on 2016/11/29.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRAboutUsViewController.h"
#import "QDRNaviTitleView.h"

@interface QDRAboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@end

@implementation QDRAboutUsViewController{
    float textViewHeight;
}

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRGBColor(227, 227, 227);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRAboutUsViewController"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWindowW, 0, 0)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}


- (float)heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor grayColor];
        _textView.text = @"免费书城提醒您：\n        在使用免费书城搜索引擎（以下简称免费书城）前，请您务必仔细阅读并透彻理解本声明。您可以选择不使用免费书城，但如果您使用免费书城，您的使用行为将被视为对本声明全部内容的认可。\n•	鉴于免费书城以非人工检索方式、根据您键入的关键字自动生成到第三方网页的链接，除免费书城注明之服务条款外，其他一切因使用免费书城而可能遭致的意外、疏忽、侵权及其造成的损失（包括因下载被搜索链接到的第三方网站内容而感染电脑病毒），免费书城对其概不负责，亦不承担任何法律责任。\n•	任何通过使用免费书城而搜索链接到的第三方网页均系他人制作或提供，您可能从该第三方网页上获得资讯及享用服务，免费书城对其合法性概不负责，亦不承担任何法律责任。\n•	免费书城搜索结果根据您键入的关键字自动搜索获得并生成，不代表免费书城赞成被搜索链接到的第三方网页上的内容或立场。\n•	您应该对使用搜索引擎的结果自行承担风险。免费书城不做任何形式的保证：不保证搜索结果满足您的要求，不保证搜索服务不中断，不保证搜索结果的安全性、正确性、及时性、合法性。因网络状况、通讯线路、第三方网站等任何原因而导致您不能正常使用免费书城，免费书城不承担任何法律责任。\n•	免费书城尊重并保护所有使用免费书城用户的个人隐私权，您注册的用户名、电子邮件地址等个人资料，非经您亲自许可或根据相关法律、法规的强制性规定，免费书城不会主动地泄露给第三方。免费书城提醒您：您在使用搜索引擎时输入的关键字将不被认为是您的个人隐私资料。\n•	任何网站如果不想被免费书城收录（即不被搜索到），应该及时向免费书城反映，或者在其网站页面中根据拒绝蜘蛛协议（Robots Exclusion Protocol）加注拒绝收录的标记，否则，免费书城将依照惯例视其为可收录网站。\n•	任何单位或个人认为通过免费书城搜索链接到的第三方网页内容可能涉嫌侵犯其信息网络传播权，应该及时向免费书城提出书面权利通知，并提供身份证明、权属证明及详细侵权情况证明。免费书城在收到上述法律文件后，将会依法尽快断开相关链接内容。详情参见特定频道的著作权保护声明。\n\n\n特别提示：\n        您在使用免费书城提供的各项服务之前，请您务必审慎阅读、充分理解本协议各条款内容，特别是以粗体标注的部分，包括但不限于免除 或者限制责任的条款。如您不同意本服务协议及/或随时对其的修改，您可以主动停止使用免费书城提供的服务；您一旦使用免费书城服务，即视为您已了解并完全同意本服 务协议各项内容，包括免费书城对服务协议随时所做的任何修改，并成为免费书城用户。\n一、总则\n1．1　用户应当同意本协议的条款并按照页面上的提示完成全部的注册程序。用户在进行注册程序过程中点击\"同意\"按钮即表示用户与免费书城所属公司达成协议，完全接受本协议项下的全部条款。\n1．2　用户注册成功后，免费书城将给予每个用户一个用户帐号及相应的密码，该用户帐号和密码由用户负责保管；用户应当对以其用户帐号进行的所有活动和事件负法律责任。\n1．3　用户一经注册免费书城帐号，除非子频道要求单独开通权限，用户有权利用该账号使用免费书城各个频道的单项服务，当用户使用免费书城各单项服务时，用户的使用行为视为其对该单项服务的服务条款以及免费书城在该单项服务中发出的各类公告的同意。\n1．4　免费书城会员服务协议以及各个频道单项服务条款和公告可由免费书城公司定时更新，并予以公示。您在使用相关服务时,应关注并遵守其所适用的相关条款。\n二、注册信息和隐私保护\n2．1　免费书城帐号（即免费书城用户ID）的所有权归免费书城，用户按注册页面引导填写信息，阅读并同意本协议且完成全部注册程序后，即可获得免费书城账号并成为免费书城用户。用户应 提供及时、详尽及准确的个人资料，并不断更新注册资料，符合及时、详尽准确的要求。所有原始键入的资料将引用为注册资料。如果因注册信息不真实或更新不及 时而引发的相关问题，免费书城不负任何责任。用户应当通过真实身份信息认证注册账号，且用户提交的账号名称、头像和简介等注册信息中不得出现违法和不良信息， 经免费书城审核，如存在上述情况，免费书城将不予注册；同时，在注册后，如发现用户以虚假信息骗取账号名称注册，或其账号头像、简介等注册信息存在违法和不良信息 的，免费书城有权不经通知单方采取限期改正、暂停使用、注销登记、收回等措施。\n2．2　免费书城账号包括账户名称和密码，您可使用设置的账 户名称（包括用户名、手机号、邮箱）和密码登录免费书城；在账号使用过程中，为了保障您的账号安全基于不同的终端以及您的使用习惯，我们可能采取不同的验证措 施识别您的身份。例如您的账户在新设备首次登录，我们可能通过密码加校验码的方式识别您的身份，验证方式包括但不限于短信验证码、服务使用信息验证。\n2．3　用户不应将其帐号、密码转让、出售或出借予他人使用，若用户授权他人使用帐户，应对被授权人在该帐户下发生所有行为负全部责任。由于账号关联用户使用信息，仅当依法律法规、司法裁定或经免费书城同意，并符合免费书城规定的用户账号转让流程的情况下，方可进行账号的转让。\n2．4　因 您个人原因导致的账号信息遗失，如需找回免费书城账号信息，请按照免费书城账号找回要求提供相应的信息，并确保提供的信息合法真实有效，若提供的信息不符合要求， 无法通过免费书城安全验证，免费书城有权拒绝提供账号找回服务；若账号的唯一凭证不再有效，免费书城有权拒绝支持账号找回。例如手机号二次出售，免费书城可拒绝支持帮助找 回原手机号绑定的帐号。\n2．5　为了防止资源占用，如您连续12 个月未使用您的免费书城账号或未通过免费书城认可的其他方式登录过您的免费书城账户，免费书城有权对该账户进行注销，您将不能再通过该账号登录名登录本网站或使用相关服 务。如该账户有关联的理财产品、待处理交易或余额，免费书城会在合理范围内协助您处理，请您按照免费书城提示的方式进行操作。\n2．6　免费书城的隐私权保护声明说明了免费书城如何收集和使用用户信息。您保证已经充分了解并同意免费书城可以据此处理用户信息。\n2．7 　免费书城可能会与合作伙伴共同向您提供您所要求的服务或者共同向您展示您可能感兴趣的内容。在信息为该项产品/服务所必须的情况下，您同意免费书城可与其分享必 要的信息。并且，免费书城会要求其确保数据安全并且禁止用于任何其他用途。除此之外，免费书城不会向任何无关第三方提供或分享信息。\n2．8　在如下情况下，免费书城可能会披露您的信息:\n（1）事先获得您的授权；\n（2）您使用共享功能；\n（3）根据法律、法规、法律程序的要求或政府主管部门的强制性要求；\n（4）以学术研究或公共利益为目的；\n（5）为维护免费书城的合法权益，例如查找、预防、处理欺诈或安全方面的问题；\n（6）符合相关服务条款或使用协议的规定。\n2．9　您知悉并授权，免费书城仅在必需的情况下使用或与关联公司同步您的信息，以为用户提供征信相关服务。\n2．10　为更好地向用户提供服务，您同意免费书城通过短信等形式向您发送相关商业性服务信息。\n三、使用规则\n3．1　用户在使用免费书城服务时，必须遵守中华人民共和国相关法律法规的规定，用户应同意将不会利用本服务进行任何违法或不正当的活动，包括但不限于下列行为:\n（1）上载、展示、张贴、传播或以其它方式传送含有下列内容之一的信息：\n　1）反对宪法所确定的基本原则的；\n　2）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n　3）损害国家荣誉和利益的；\n　4）煽动民族仇恨、民族歧视、破坏民族团结的；\n　5）破坏国家宗教政策，宣扬邪教和封建迷信的；\n　6）散布谣言，扰乱社会秩序，破坏社会稳定的；\n　7）散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n　8）侮辱或者诽谤他人，侵害他人合法权利的；\n　9）含有虚假、有害、胁迫、侵害他人隐私、骚扰、侵害、中伤、粗俗、猥亵、或其它道德上令人反感的内容；\n　10）含有中国法律、法规、规章、条例以及任何具有法律效力之规范所限制或禁止的其它内容的；\n（2）不得为任何非法目的而使用网络服务系统；\n（3）不利用免费书城服务从事以下活动：\n　　1) 未经允许，进入计算机信息网络或者使用计算机信息网络资源的；\n　　2) 未经允许，对计算机信息网络功能进行删除、修改或者增加的；\n　　3) 未经允许，对进入计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加的；\n　　4) 故意制作、传播计算机病毒等破坏性程序的；\n　　5) 其他危害计算机信息网络安全的行为。\n3．2　用 户违反本协议或相关的服务条款的规定，导致或产生的任何第三方主张的任何索赔、要求或损失，包括合理的律师费，您同意赔偿免费书城与合作公司、关联公司，并使 之免受损害。对此，免费书城有权视用户的行为性质，采取包括但不限于删除用户发布信息内容、暂停使用许可、终止服务、限制使用、回收免费书城帐号、追究法律责任等 措施。对恶意注册免费书城帐号或利用免费书城帐号进行违法活动、捣乱、骚扰、欺骗、其他用户以及其他违反本协议的行为，免费书城有权回收其帐号。同时，免费书城公司会视司 法部门的要求，协助调查。\n3．3　用户不得对本服务任何部分或本服务之使用或获得，进行复制、拷贝、出售、转售或用于任何其它商业目的。\n3．4　用户须对自己在使用免费书城服务过程中的行为承担法律责任。用户承担法律责任的形式包括但不限于：对受到侵害者进行赔偿，以及在免费书城归属公司首先承担了因用户行为导致的行政处罚或侵权损害赔偿责任后，用户应给予免费书城归属公司等额的赔偿。\n四、服务内容\n4．1　免费书城网络服务的具体内容由免费书城根据实际情况提供。\n4．2　除非本服务协议另有其它明示规定，免费书城所推出的新产品、新功能、新服务，均受到本服务协议之规范。\n4．3　为使用本服务，您必须能够自行经有法律资格对您提供互联网接入服务的第三方，进入国际互联网，并应自行支付相关服务费用。此外，您必须自行配备及负责与国际联网连线所需之一切必要装备，包括计算机、数据机或其它存取装置。\n4．4　鉴于网络服务的特殊性，用户同意免费书城有权不经事先通知，随时变更、中断或终止部分或全部的网络服务（包括收费网络服务）。免费书城不担保网络服务不会中断，对网络服务的及时性、安全性、准确性也都不作担保。4．5　免责声明：因以下情况造成网络服务在合理时间内的中断，免费书城无需为此承担任何责任；\n（1）免费书城需要定期或不定期地对提供网络服务的平台或相关的设备进行检修或者维护，免费书城保留不经事先通知为维修保养、升级或其它目的暂停本服务任何部分的权利。\n（2）因台风、地震、洪水、雷电或恐怖袭击等不可抗力原因；\n（3）用户的电脑软硬件和通信线路、供电线路出现故障的；\n（4）因病毒、木马、恶意程序攻击、网络拥堵、系统不稳定、系统或设备故障、通讯故障、电力故障、银行原因、第三方服务瑕疵或政府行为等原因。\n尽管有前款约定，免费书城将采取合理行动积极促使服务恢复正常。\n4．6　本 服务或第三人可提供与其它国际互联网上之网站或资源之链接。由于免费书城无法控制这些网站及资源，您了解并同意，此类网站或资源是否可供利用，免费书城不予负责， 存在或源于此类网站或资源之任何内容、广告、产品或其它资料，免费书城亦不予保证或负责。因使用或依赖任何此类网站或资源发布的或经由此类网站或资源获得的任 何内容、商品或服务所产生的任何损害或损失，免费书城不承担任何责任。\n4．7　用户明确同意其使用免费书城网络服务所存在的风险将完全由其自己承担。用户理解并接受下载或通过免费书城服务取得的任何信息资料取决于用户自己，并由其承担系统受损、资料丢失以及其它任何风险。免费书城对在服务网上得到的任何商品购物服务、交易进程、招聘信息，都不作担保。\n4．8　用户须知：免费书城提供的各种挖掘推送服务中（包括免费书城新首页的导航网址推送），推送给用户曾经访问过的网站或资源之链接是基于机器算法自动推出，免费书城不对其内容的有效性、安全性、合法性等做任何担保。\n4．9　免费书城有权于任何时间暂时或永久修改或终止本服务（或其任何部分），而无论其通知与否，免费书城对用户和任何第三人均无需承担任何责任。\n4．10　终止服务\n您 同意免费书城得基于其自行之考虑，因任何理由，包含但不限于长时间（超过一年）未使用，或免费书城认为您已经违反本服务协议的文字及精神，终止您的密码、帐号或本 服务之使用（或服务之任何部分），并将您在本服务内任何内容加以移除并删除。您同意依本服务协议任何规定提供之本服务，无需进行事先通知即可中断或终止， 您承认并同意，免费书城可立即关闭或删除您的帐号及您帐号中所有相关信息及文件，及/或禁止继续使用前述文件或本服务。此外，您同意若本服务之使用被中断或终 止或您的帐号及相关信息和文件被关闭或删除，免费书城对您或任何第三人均不承担任何责任。\n五、知识产权和其他合法权益（包括但不限于名誉权、商誉权）\n5．1　用户专属权利\n免费书城尊重他人知识产权和合法权益，呼吁用户也要同样尊重知识产权和他人合法权益。若您认为您的知识产权或其他合法权益被侵犯，请按照以下说明向免费书城提供资料∶\n请注意：如果权利通知的陈述失实，权利通知提交者将承担对由此造成的全部法律责任（包括但不限于赔偿各种费用及律师费）。如果上述个人或单位不确定网络上可获取的资料是否侵犯了其知识产权和其他合法权益，免费书城建议该个人或单位首先咨询专业人士。\n为了免费书城有效处理上述个人或单位的权利通知，请使用以下格式（包括各条款的序号）：\n1. 权利人对涉嫌侵权内容拥有知识产权或其他合法权益和/或依法可以行使知识产权或其他合法权益的权属证明；\n2. 请充分、明确地描述被侵犯了知识产权或其他合法权益的情况并请提供涉嫌侵权的第三方网址（如果有）。\n3. 请指明涉嫌侵权网页的哪些内容侵犯了第2项中列明的权利。\n4. 请提供权利人具体的联络信息，包括姓名、身份证或护照复印件（对自然人）、单位登记证明复印件（对单位）、通信地址、电话号码、传真和电子邮件。\n5. 请提供涉嫌侵权内容在信息网络上的位置（如指明您举报的含有侵权内容的出处，即：指网页地址或网页内的位置）以便我们与您举报的含有侵权内容的网页的所有权人/管理人联系。\n6. 请在权利通知中加入如下关于通知内容真实性的声明： “我保证，本通知中所述信息是充分、真实、准确的，如果本权利通知内容不完全属实，本人将承担由此产生的一切法律责任。”\n7. 请您签署该文件，如果您是依法成立的机构或组织，请您加盖公章。\n请您把以上资料和联络方式书面发往以下地址：\n中国北京市朝阳区北京像素北区4-302\n免费书城　产品事务组\n邮政编码：100024\n5．2 　对于用户通过免费书城服务上传到免费书城网站上可公开获取区域的任何内容，用户同意免费书城在全世界范围内具有免费的、永久性 的、不可撤销的、非独家的和完全再许可的权利和许可，以使用、复制、修改、改编、出版、翻译、据以创作衍生作品、传播、表演和展示此等内容（整体或部 分），和/或将此等内容编入当前已知的或以后开发的其他任何形式的作品、媒体或技术中。\n5．3　免费书城拥有本网站内所有资料的版权。任何被授权的浏览、复制、打印和传播属于本网站内的资料必须符合以下条件：\n　　所有的资料和图象均以获得信息为目的；\n　　所有的资料和图象均不得用于商业目的；\n　　所有的资料、图象及其任何部分都必须包括此版权声明；\n　　本应用所有的产品、技术与所有程序均属于免费书城知识产权，在此并未授权。　　\n　　未经免费书城许可，任何人不得擅自（包括但不限于：以非法的方式复制、传播、展示、镜像、上载、下载）使用。否则，免费书城将依法追究法律责任。\n六、青少年用户特别提示\n青少年用户必须遵守全国青少年网络文明公约：\n要善于网上学习，不浏览不良信息；要诚实友好交流，不侮辱欺诈他人；要增强自护意识，不随意约会网友；要维护网络安全，不破坏网络秩序；要有益身心健康，不沉溺虚拟时空。\n七、其他\n7．1　本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。\n7．2　如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向免费书城所在地的人民法院提起诉讼。\n7．3　免费书城未行使或执行本服务协议任何权利或规定，不构成对前述权利或权利之放弃。\n7．4　如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n请您在发现任何违反本服务协议以及其他任何单项服务的服务条款、免费书城各类公告之情形时，通知免费书城。您可以通过如下联络方式同免费书城联系：\n中国北京市朝阳区北京像素北区4-302\n免费书城　产品事务组\n邮政编码：100024\n";
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_HEADERURL]]];
    }
    return _headerImageView;
}

- (void)setNavigationController
{
    self.naviTitleView.titleLabel.text = @"免责声明";
    self.naviTitleView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = self.naviTitleView;
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self setNavigationController];
    
    [self textView];
    textViewHeight = [self heightForString:self.textView andWidth:(kWindowW - 20)];
    
    [self headerImageView];
    [self tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRAboutUsViewController" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }else{
        [cell.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath.row == 0 ? 100 : textViewHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

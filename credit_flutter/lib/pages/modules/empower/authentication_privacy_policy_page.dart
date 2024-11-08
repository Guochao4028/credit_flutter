/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-27 13:41
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:flutter/material.dart';

class AuthenticationPrivacyPolicyPage extends StatefulWidget {
  AuthenticationPrivacyPolicyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthenticationPrivacyPolicyPage> createState() =>
      _AuthenticationPrivacyPolicyPageState();
}

class _AuthenticationPrivacyPolicyPageState
    extends State<AuthenticationPrivacyPolicyPage> {
  bool bottom = false;
  ScrollController _controller = ScrollController();

  bool isTime = false;

  var titleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  var contentStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  Timer? _timer;

  //倒计时数值
  var countdownTime = 0;

  //倒计时方法
  startCountdown() {
    countdownTime = 5;
    call(timer) {
      if (countdownTime < 2) {
        _timer?.cancel();
        isTime = true;
      } else {
        countdownTime -= 1;
      }
      setState(() {});
    }

    _timer = Timer.periodic(const Duration(seconds: 1), call);
  }

  String handleCodeText() {
    if (!isTime) {
      return "${countdownTime}s";
    } else {
      return "我已阅读";
    }
  }

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          bottom = true;
        });
      }
    });
    startCountdown();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "隐私政策",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ListView(
            padding:
                const EdgeInsets.only(left: 18, top: 12, right: 18, bottom: 75),
            controller: _controller,
            children: [
              Text(
                "简介",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查致力于为其客户（“客户”）提供雇佣前和雇佣中的背景验证服务（“服务”）。为遵守《中华人民共和国个人信息保护法》（“个人信息保护法”），客户为个人信息处理者，慧眼查为个人信息保护法第21条规定的受托方。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查尊重您的隐私并致力于保护您的个人信息，本隐私政策旨在解释慧眼查在服务过程中如何使用您的个人数据，并遵守本隐私政策和个人信息保护法的规定。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "本政策描述了慧眼查如何处理您的个人数据。除本政策外，您还可以访问在收集和/或处理您的个人数据时提供给您的补充文件、视频和/或通知。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查与其客户的关系",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查作为客户指定的受托处理方进行服务，并已与客户签订协议，其中包括以下条款：",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "1、委托处理的目的；",
                style: contentStyle,
              ),
              Text(
                "2、处理方式；",
                style: contentStyle,
              ),
              Text(
                "3、个人信息类别；",
                style: contentStyle,
              ),
              Text(
                "4、保护措施；",
                style: contentStyle,
              ),
              Text(
                "5、慧眼查和客户的权利与义务；",
                style: contentStyle,
              ),
              Text(
                "6、审计权利；",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查根据与客户的协议条款处理所有个人信息，并且仅在他们的指示下行事。慧眼查不会出于任何其他目的收集、处理或存储个人信息来向其客户提供服务。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "在某些情况下，慧眼查需要将您的个人数据发送给第三方。此类第三方可能是",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您的雇主或协助执行服务的第三方供应商。客户已同意根据协议条款将个人信息传输给此类第三方。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "服务如何运行？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查在客户的指示下行事，客户将决定收集和处理哪些个人数据并提供服务。如需了解更多有关正在收集何种信息以及为何收集信息，请与您的未来雇主或雇主进行沟通。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您将通过我们的客户生成的候选人邀请来参与到服务中。服务将通过一个安全的平台（“服务平台”）提供，您可以通过候选人邀请中提供的安全链接进行访问该服务平台。当您访问了该服务平台时，您将被要求阅读信息通知，其中包含您需要了解的有关服务的所有详细信息。只有在您阅读并理解信息通知后，您才会被要求将个人数据输入至服务平台。同时您有权根据个人意愿，自行决定是否通过人脸识别或者指纹识别接受该邀请，并通过签署电子合同授权我们处理您的个人数据。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "你以什么理由处理我的个人数据？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您需要向慧眼查提供同意/授权，允许我们代表客户收集和处理您的个人数据。您将获得足够的信息，以确保您的同意是在充分知情的条件下作出的。在您阅读并理解信息通知之前，您不会被要求提供您的同意，如果您对服务的性质和处理您的个人数据的程度有任何疑问，欢迎联系您的未来雇主或雇主，以便您可以进行选择和控制。通过服务平台向您提供的信息通知和最终同意书中列出了要执行的每种类型的验证。此外，如果某些数据来源需要您的单独的同意，则在处理任何个人数据或将其发送到该数据来源之前，我们将向您提供相应表格供您签名。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您可以随时撤回您的同意，并且慧眼查有相应的处理流程。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "我们收集哪些个人数据？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "根据个人信息保护法，“个人信息”指与已识别或可识别的自然人有关的任何信息，无论是以电子或其他格式记录的，但不包括匿名信息。“敏感个人信息”是指如果被泄露或者被非法使用，可能对自然人的人格尊严造成损害、危及人身安全或者财产安全的个人信息。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "为了提供服务，并确保向客户报告的任何信息准确无误，我们必须收集您的个人数据。您将被要求仅提供执行服务所需的个人数据。可能需要的个人数据类型如下：",
                style: contentStyle,
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: CustomColors.greyBlack,
                    width: 1,
                  ),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    _getItem("个人数据的类型", "收集原因"),
                    _getItem("姓名（包括曾用名）",
                        "这是我们在执行服务时能够识别您的方式。我们要求您提供政府签发的身份证件上显示的姓名，以及您可能被知晓的曾用名。这一点很重要，尤其是当您被行业所熟知的姓名可能与您在政府签发的身份证件上显示的姓名不同时。"),
                    _getItem("联系方式",
                        "这是为了确保慧眼查在提供服务期间可以与您保持联系。慧眼查不会将您的联系方式用于任何其他目的，并且这些详细信息会根据我们客户设置的保留政策从服务平台中删除。"),
                    _getItem("工作经历", "您的未来雇主或雇主要求根据搜索深度验证此信息。"),
                    _getItem("教育经历", "您的未来雇主或雇主要求验证此信息，并且在大多数情况下要求最高教育水平。"),
                    _getItem("证明人",
                        "为了支持您的工作经历的验证，您可能会被要求提供证明人的联系方式。您必须始终确保您得到证明人的同意。这些联系方式不会与任何第三方共享。"),
                    _getItem(
                        "身份证件号码", "获取信息的来源可能需要这样做，因为该来源保存的记录与政府签发的身份证件号码相关联。"),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: Center(
                                child: Text(
                                  "支持文件",
                                  style: contentStyle,
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: CustomColors.greyBlack,
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: Center(
                                child: Text(
                                  "在服务过程中，您可能会被要求提供支持文件。 这些支持文件可能包括许多材料，并将取决于慧眼查客户要求的服务类型。 例如，您可能会被要求上传（在合法的情况下）政府签发的您的身份证件的副本；显示专业资格的证书；用于证明您的工作经历的文件。",
                                  style: contentStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "您在登录服务平台时，信息通知将会提供我们会收集的个人数据以及这些个人数据将用于哪些服务的更多详细信息。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查会使用 cookie 吗？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "服务平台仅在您的网络会话期间收集存储在您计算机上的会话 cookie。当浏览器关闭时，它们会被自动删除。它们通常会存储一个匿名会话 ID，使您无需登录每个页面即可浏览网站。他们不会从您的计算机上收集任何信息。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您的哪些个人数据会被处理？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "在服务期间内将由慧眼查的客户确定会被处理的个人数据。慧眼查的客户可能会要求验证您的工作和教育背景，但也可能要求其他定制的服务，例如验证任何信用、犯罪或公开来源的信息。？",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "所有相关信息将在您将访问的服务平台上的信息通知中列出，以便您充分了解服务的性质。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "我的个人数据存储在哪里以及慧眼查如何确保其安全？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您的个人数据将直接存储至搭建在中国境内阿里云服务器上的服务平台上。服务平台已通过 ISO27001认证、ISO9001认证以及国家信息安全等级保护三级认证，并采取措施保护个人数据免受意外丢失和未经授权的访问、使用、更改或披露，并采取信息安全措施，包括访问控制、物理安全和完善的信息收集、存储和处理实践。 慧眼查还确保在向/从其代表进行个人数据电子传输的环节，也受到适当保护，并符合相关数据保护法规以及数据来源提供的任何指示。慧眼查与客户签订了合同来确保对所有个人数据传输提供足够的数据保护。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查何时传输数据？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "在以下情况下，您的个人数据可能会被传输：",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "1、在服务结束时以核查报告的形式向慧眼查的客户提供；",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "2、提供给第三方以履行服务。这些第三方可能会位于中华人民共和国境外，如您有海外的学习、工作、生活经历，客户需要对其进行核查时；",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "【提供至慧眼查的客户：】",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                '作为服务的一部分，慧眼查会将最终的数据处理结果生成一份核查报告，详细说明针对您通过服务平台提供给我们的个人数据执行的任何验证的结果。该筛查报告由相关的慧眼查客户访问。',
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "每个慧眼查客户都有自己的安全帐户并指定该帐户的用户，包括对报告的访问权限，以确保核查报告的最大安全性。许多客户选择直接从他们的安全帐户查看核查报告，但有些客户可能会选择下载核查报告的副本并保留在他们自己的系统中。您应该联系您的未来雇主/雇主以获取更多信息。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "【提供至第三方：】",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "第三方是仅出于履行服务的目的而收集信息的组织、机构、代理或个人，可能包括当地的供应商、雇主、教育机构、推荐人、政府机构、法院、数据提供者或存储库（“数据来源”）或正在执行与服务相关的特定研究的慧眼查代表（“代表”）（统称为“第三方”）。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "关于将您的个人数据传输到中华人民共和国以外的一个或多个数据来源，这将取决于您在慧眼查客户设置的筛选期内的记录。如果您的记录在中华人民共和国境外，您的个人数据将需要从相关数据来源进行比对核实。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                '我们只会根据合法、公平、必要和诚实信用的原则，为特定和明确的目的传输您的个人信息，并且仅在您被告知的特定目的所需的范围内传输个人信息。',
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查是否会进行任何自动化决策？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "不会：我们不会就您或您的个人数据做出任何决策，无论是自动化方式还是其他方式。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查是否出于提供服务以外的任何原因使用个人数据？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "不会：您的个人数据仅用于提供服务。服务完成后，您的个人数据将从服务平台中删除以符合数据存储期限的要求。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "个人数据会保留多久？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "慧眼查在服务平台上的标准数据保留政策是自筛选报告完成之日起 6 个月。但客户可以设置他们自己定制的保留期限，他们将根据您的要求将该等保留期限提供给您。信息通知中明确设定了数据保留期限。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您如何根据相关隐私法律行使您的权利？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "对于将要处理的与雇佣前筛查相关的个人数据，您拥有隐私法律规定的特定的权 利，例如访问权、更正权和删除权。根据此类相关隐私立法，您可向个人信息处理者（慧眼查的客户和您的潜在雇主/雇主）行使这些权利，您应将请求发送至他们提供给您的地址。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "如何撤回我对慧眼查处理我的个人数据的授权许可？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "由于您的个人数据是在您同意的情况下被处理的，因此您有权随时撤回该授权许可。为此，您可以选择：",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "(1) 联系个人信息处理者，他们会将您的请求通知给慧眼查；",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "(2) 联系huiyancha2021@163.com，我们将停止处理您的个人数据，无论是您的全部个人数据还是与撤回授权相关的特定部分。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "如果您直接联系慧眼查，我们将联系相关客户，通知他们授权许可已被撤回。只有在您恢复同意后才会重新开始处理。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "您可以与个人信息处理者（您的未来雇主/雇主）沟通，表述导致您撤回同意的任何疑虑或原因。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "请注意，如果在您撤回授权之前对您的个人数据慧眼查已经进行了任何处理，则此类处理将不受此类撤回的影响。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "我该如何投诉？",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "我们承诺以让您感到舒适和安心的方式处理您的个人数据。但是，如果您在任何时候对您的个人数据的处理有疑虑，我们鼓励您联系个人信息处理者（您的潜在雇主/雇主），慧眼查将配合任何调查以解决任何问题。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "如果您想直接联系慧眼查，请发送电子邮件至huiyancha2021@163.com。我们致力于保护您的个人数据，并调查和解决有关我们收集或使用您的个人数据的任何投诉。",
                style: contentStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "隐私政策的更改",
                style: titleStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "我们会不时更改本政策，以使其准确反映我们的做法和法律要求。请定期查看本页面的更改，以了解我们的隐私政策。您在本隐私政策修订后继续使用我们的网站和服务，即表示您同意并遵守新的隐私政策。",
                style: contentStyle,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            height: 45,
            decoration: BoxDecoration(
              color: isTime && bottom
                  ? const Color(0xFF1B7CF6)
                  : const Color.fromRGBO(200, 200, 200, 0.7),
              borderRadius: const BorderRadius.all(Radius.circular(22.5)),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (isTime && bottom) {
                  Navigator.of(context).pop("ok");
                }
              },
              child: Center(
                child: Text(
                  handleCodeText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getItem(String s, String t) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      s,
                      style: contentStyle,
                    ),
                  ),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomColors.greyBlack,
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      t,
                      style: contentStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomColors.greyBlack,
        ),
      ],
    );
  }
}

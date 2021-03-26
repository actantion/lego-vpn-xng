//
//  ProxyConfHelper.m
//  ShadowsocksX-NG
//
//  Created by 邱宇舟 on 16/6/10.
//  Copyright © 2016年 qiuyuzhou. All rights reserved.
//

#import "ProxyConfHelper.h"
#import "proxy_conf_helper_version.h"

#define kShadowsocksHelper @"/Library/Application Support/ShadowsocksX-NG/proxy_conf_helper"

@implementation ProxyConfHelper

GCDWebServer *webServer = nil;

+ (BOOL)isVersionOk {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:kShadowsocksHelper];
    
    NSArray *args;
    args = [NSArray arrayWithObjects:@"-v", nil];
    [task setArguments: args];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *fd;
    fd = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [fd readDataToEndOfFile];
    
    NSString *str;
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (![str isGreaterThanOrEqualTo: kProxyConfHelperVersion]) {
        return NO;
    }
    return YES;
}

+ (void)install {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:kShadowsocksHelper] || ![self isVersionOk]) {
        NSString *helperPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"install_helper.sh"];
        NSLog(@"run install script: %@", helperPath);
        NSDictionary *error;
        NSString *script = [NSString stringWithFormat:@"do shell script \"/bin/bash \\\"%@\\\"\" with administrator privileges", helperPath];
        NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
        if ([appleScript executeAndReturnError:&error]) {
            NSLog(@"installation success");
        } else {
            NSLog(@"installation failure: %@", error);
        }
    }
}

+ (void)callHelper:(NSArray*) arguments {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:kShadowsocksHelper];

    // this log is very important
    NSLog(@"run shadowsocks helper: %@", kShadowsocksHelper);
    [task setArguments:arguments];

    NSPipe *stdoutpipe;
    stdoutpipe = [NSPipe pipe];
    [task setStandardOutput:stdoutpipe];

    NSPipe *stderrpipe;
    stderrpipe = [NSPipe pipe];
    [task setStandardError:stderrpipe];

    NSFileHandle *file;
    file = [stdoutpipe fileHandleForReading];

    [task launch];

    NSData *data;
    data = [file readDataToEndOfFile];

    NSString *string;
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string.length > 0) {
        NSLog(@"%@", string);
    }

    file = [stderrpipe fileHandleForReading];
    data = [file readDataToEndOfFile];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string.length > 0) {
        NSLog(@"%@", string);
    }
}

+ (void)addArguments4ManualSpecifyNetworkServices:(NSMutableArray*) args {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"AutoConfigureNetworkServices"]) {
        NSArray* serviceKeys = [defaults arrayForKey:@"Proxy4NetworkServices"];
        if (serviceKeys) {
            for (NSString* key in serviceKeys) {
                [args addObject:@"--network-service"];
                [args addObject:key];
            }
        }
    }
}

+ (void)addArguments4ManualSpecifyProxyExceptionsUserDef:(NSMutableArray*) args {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSString* rawExceptions = [defaults stringForKey:@"ProxyExceptions"];
    rawExceptions = [NSString stringWithFormat:@"%@%@", rawExceptions, @",*.10010.com,*.115.com,*.123u.com,*.126.com,*.126.net,*.163.com,*.17173.com,*.178.com,*.17cdn.com,*.21cn.com,*.2288.org,*.3322.org,*.360buy.com,*.360buyimg.com,*.360doc.com,*.360safe.com,*.36kr.com,*.400gb.com,*.4399.com,*.51.la,*.51buy.com,*.51cto.com,*.51job.com,*.51jobcdn.com,*.5d6d.com,*.5d6d.net,*.61.com,*.6600.org,*.6rooms.com,*.7766.org,*.7k7k.com,*.8800.org,*.8866.org,*.90g.org,*.91.com,*.9966.org,*.acfun.tv,*.aicdn.com,*.ali213.net,*.alibaba.com,*.alicdn.com,*.aliexpress.com,*.aliimg.com,*.alikunlun.com,*.alimama.com,*.alipay.com,*.alipayobjects.com,*.alisoft.com,*.aliyun.com,*.aliyuncdn.com,*.aliyuncs.com,*.anzhi.com,*.appinn.com,*.appdownload.itunes.apple.com,*.apple.com,*.appsina.com,*.archlinuxcn.org,*.atpanel.com,*.baidu.com,*.baidupcs.com,*.baidustatic.com,*.baifendian.com,*.baihe.com,*.baixing.com,*.bdimg.com,*.bdstatic.com,*.bilibili.tv,*.blogbus.com,*.blueidea.com,*.ccb.com,*.cctv.com,*.cctvpic.com,*.cdn20.com,*.china.com,*.chinabyte.com,*.chinacache.com,*.chinacache.net,*.chinacaipu.com,*.chinagba.com,*.chinahr.com,*.chinajoy.net,*.chinamobile.com,*.chinanetcenter.com,*.chinanews.com,*.chinapnr.com,*.chinaren.com,*.chinaspeeds.net,*.chinaunix.net,*.chinaz.com,*.chint.com,*.chiphell.com,*.chuangxin.com,*.ci123.com,*.ciku5.com,*.citysbs.com,*.class.coursera.org,*.cloudcdn.net,*.cmbchina.com,*.cmfu.com,*.cmread.com,*.cmwb.com,*.cn.archive.ubuntu.com,*.cn.bing.com,*.cn.coremetrics.com,*.cn.debian.org,*.cn.msn.com,*.cn,*.cnak2.englishtown.com,*.cnbeta.com,*.cnbetacdn.com,*.cnblogs.com,*.cnepub.com,*.cnzz.com,*.comsenz.com,*.csdn.net,*.ct10000.com,*.ctdisk.com,*.dangdang.com,*.dbank.com,*.dedecms.com,*.diandian.com,*.dianping.com,*.discuz.com,*.discuz.net,*.dl.google.com,*.docin.com,*.donews.com,*.dospy.com,*.douban.com,*.douban.fm,*.duapp.com,*.duba.net,*.duomi.com,*.duote.com,*.duowan.com,*.egou.com,*.et8.org,*.etao.com,*.f3322.org,*.fantong.com,*.fenzhi.com,*.fhldns.com,*.ganji.com,*.gaopeng.com,*.geekpark.net,*.gfan.com,*.gtimg.com,*.hacdn.net,*.hadns.net,*.hao123.com,*.hao123img.com,*.hc360.com,*.hdslb.com,*.hexun.com,*.hiapk.com,*.hichina.com,*.hoopchina.com,*.huanqiu.com,*.hudong.com,*.huochepiao.com,*.hupu.com,*.iask.com,*.iciba.com,*.idqqimg.com,*.ifanr.com,*.ifeng.com,*.ifengimg.com,*.ijinshan.com,*.iqiyi.com,*.it168.com,*.itcpn.net,*.iteye.com,*.itouzi.com,*.jandan.net,*.jd.com,*.jiashule.com,*.jiasule.com,*.jiathis.com,*.jiayuan.com,*.jiepang.com,*.jing.fm,*.jobbole.com,*.jstv.com,*.jumei.com,*.kaixin001.com,*.kandian.com,*.kandian.net,*.kanimg.com,*.kankanews.com,*.kdnet.net,*.koudai8.com,*.ku6.com,*.ku6cdn.com,*.ku6img.com,*.kuaidi100.com,*.kugou.com,*.lashou.com,*.letao.com,*.letv.com,*.lietou.com,*.linezing.com,*.loli.mg,*.loli.vg,*.lvping.com,*.lxdns.com,*.mangocity.com,*.mapbar.com,*.mcbbs.net,*.mediav.com,*.meilishuo.com,*.meituan.com,*.meituan.net,*.meizu.com,*.microsoft.com,*.miui.com,*.moe123.com,*.moegirl.org,*.mop.com,*.mtime.com,*.my-card.in,*.mydrivers.com,*.mzstatic.com,*.netease.com,*.newsmth.net,*.ngacn.cc,*.nuomi.com,*.okbuy.com,*.optaim.com,*.oschina.net,*.paipai.com,*.pcbeta.com,*.pchome.net,*.pcpop.com,*.pengyou.com,*.phoenixlzx.com,*.phpwind.net,*.pingan.com,*.pool.ntp.org,*.pplive.com,*.pps.tv,*.ppstream.com,*.pptv.com,*.pubyun.com,*.qhimg.com,*.qianlong.com,*.qidian.com,*.qingdaonews.com,*.qiniu.com,*.qiniudn.com,*.qiushibaike.com,*.qiyi.com,*.qiyipic.com,*.qq.com,*.qqmail.com,*.qstatic.com,*.qunar.com,*.qunarzz.com,*.qvbuy.com,*.renren.com,*.renrendai.com,*.rrfmn.com,*.rrimg.com,*.sanguosha.com,*.sdo.com,*.sina.com,*.sinaapp.com,*.sinaedge.com,*.sinaimg.com,*.sinajs.com,*.skycn.com,*.smzdm.com,*.sogou.com,*.sohu.com,*.soku.com,*.solidot.org,*.soso.com,*.soufun.com,*.soufunimg.com,*.staticfile.org,*.staticsdo.com,*.steamcn.com,*.suning.com,*.szzfgjj.com,*.tanx.com,*.taobao.com,*.taobaocdn.com,*.tbcache.com,*.tdimg.com,*.tencent.com,*.tenpay.com,*.tgbus.com,*.thawte.com,*.tiancity.com,*.tianyaui.com,*.tiexue.net,*.tmall.com,*.tmcdn.net,*.tom.com,*.tomonline-inc.com,*.tuan800.com,*.tuan800.net,*.tuanimg.com,*.tudou.com,*.tudouui.com,*.tuniu.com,*.u148.net,*.u17.com,*.ubuntu.com,*.ucjoy.com,*.uni-marketers.com,*.unionpay.com,*.unionpaysecure.com,*.upaiyun.com,*.upyun.com,*.uusee.com,*.uuu9.com,*.vaikan.com,*.vancl.com,*.vcimg.com,*.verycd.com,*.wandoujia.com,*.wdjimg.com,*.weibo.com,*.weiphone.com,*.weiyun.com,*.west263.com,*.wrating.com,*.wscdns.com,*.wumii.com,*.xdcdn.net,*.xiachufang.com,*.xiami.com,*.xiami.net,*.xiaomi.com,*.xiaonei.com,*.xiazaiba.com,*.xici.net,*.xilu.com,*.xinhuanet.com,*.xinnet.com,*.xlpan.com,*.xn--fiqs8s,*.xnpic.com,*.xungou.com,*.xunlei.com,*.ydstatic.com,*.yesky.com,*.yeyou.com,*.yihaodian.com,*.yihaodianimg.com,*.yingjiesheng.com,*.yintai.com,*.yinyuetai.com,*.yiqifa.com,*.yixun.com,*.ykimg.com,*.ynet.com,*.youdao.com,*.yougou.com,*.youku.com,*.yupoo.com,*.yy.com,*.zbjimg.com,*.zhaopin.com,*.zhi.hu,*.zhihu.com,*.zhimg.com,*.zhubajie.com,*.zongheng.com,*zoopda.com,*yixun.com,*jd.com,*zdmimg.com,*appgame.com,*qiniucdn.com,*wangyin.com,*gewara.com,*ele.me,*teambition.com,*anquanbao.com,*ziroom.com,*guokr.com,*speedtest.net,*huazhu.com,*saraba1st.com*icson.com*0x110.com,*100tjs.com,*115img.com,*123cha.com,*126.net,*1717388.com,*17cdn.com,*17kuxun.com,*198game.com,*1uuc.com,*24quan.com,*293.net,*2mdn.net,*360buyimg.com,*360tl.com,*37see.com,*5000pk.com,*51img1.com,*51jobcdn.com,*51yes.com,*5d6d.com,*6dad.com,*6rooms.com,*701sou.com,*766.com,*859652.com,*968tl.com,*9787.com,*99114.com,*a963.com,*acfun.tv,*adnxs.com,*adroll.com,*adsame.com,*adsonar.com,*adtechus.com,*alicdn.com,*aliimg.com,*alipayobjects.com,*aliyun.com,*appinn.com,*atdmt.com,*atpanel.com,*bdimg.com,*bdstatic.com,*bestb2b.com,*betrad.com,*bjbus.com,*blogbus.com,*bluekai.com,*bokee.net,*boosj.com,*brothersoft.com,*cache.netease.com,*caing.com,*cctv.com,*cctvcom,*cdn20.com,*changyou.com,*chdbits.org,*chetx.com,*chinamobile.com,*chinaren.com,*chiphell.com,*cnepub.com,*cnfol.com,*cngba.com,*cntv.net,*cnwest.com,*compete.com,*cqtiyu.com,*didatuan.com,*dipan.com,*douban.fm,*doubleclick.net,*dpfile.com,*dream4ever.org,*duapp.com,*duomi.com,*dy2018.com,*dytt8.net,*eb80.com,*egou.com,*ellechina.com,*et8.org,*eyoudi.com,*fantong.com,*fastcdn.com,*fastif.net,*fat999.com,*ffdy.cc,*ftchinese.com,*game3896.com,*gamesville.com,*gamewan.net,*gaopeng.com,*getfirebug.com,*gfw.io,*ggmm777.com,*go2map.com,*goodbabygroup.com,*google-analytics.com,*gtimg.com,*gy9y.com,*gzmama.com,*haliyuya.com,*harrenmedianetwork.com,*hdslb.com,*help.apple.com,*hi-pda.com,*hlwan.net,*homeinns.com,*hoopchina.com,*huochepiao.com,*iask.com,*ibm.com,*icson.com,*idailyapp.com,*ifengimg.com,*ifensi.com,*ijinshan.com,*img-space.com,*img.cctvpic.com,*imrworldwide.com,*inc.gs,*infzm.com,*invitemedia.com,*ipinyou.com,*irs01.com,*irs01.net,*is686.com,*iweek.ly,*james520.com,*jandan.net,*jianshu.io,*jiatx.com,*jiepang.com,*jing.fm,*jiuyaoyouxi.com,*jjwxc.net,*joqoo.com,*jstv.com,*junshijia.com,*jysq.net,*kandian.com,*kandian.net,*kanimg.com,*kankan.com,*keyunzhan.com,*koudai8.com,*ku6cdn.com,*ku6img.com,*kuaidi100.com,*kuaiwan.com,*lampdrive.com,*lashouimg.com,*legolas-media.com,*letao.com,*local,*localhost,*logmein.com,*lohas.ly,*loli.mg,*loli.vg,*love21cn.com,*lvping.com,*lxdns.com,*lycos.com,*lygo.com,*mapabc.com,*mathtag.com,*mediaplex.com,*mediav.com,*miaozhen.com,*mlt01.com,*mmstat.com,*mookie1.com,*mosso.com,*mozilla.org,*my.cl.ly,*nbweekly.com,*ngacn.cc,*njobt.com,*oadz.com,*okbuy.com,*okooo.com,*p5w.net,*pcbeta.com,*pixlr.com,*pplive.com,*pr56789.com,*ptlogin2.qq.com,*pubmatic.com,*qiyi.com,*qiyipic.com,*qqmail.com,*qstatic.com,*quantserve.com,*qvbuy.com,*ranwen.com,*rrimg.com,*rtbidder.net,*sanguosha.com,*scanscout.com,*scorecardresearch.com,*serving-sys.com,*sg560.com,*shuangtv.net,*sina.com,*sinaapp.com,*sinaedge.com,*sinahk.net,*sinaimg.com,*sinajs.com,*sj-tl.com,*skycn.com,*snsfun.cc,*snyu.com,*soufunimg.com,*stackoverflow.com,*staticsdo.com,*synacast.com,*tanx.com,*tbcache.com,*tdimg.com,*tencent.com,*thawte.com,*tianyaui.com,*tlbb2.com,*tlbb8.com,*tlbbsifu.com,*tremormedia.com,*tudouui.com,*typecho.org,*tvmao.com,*umiwi.com,*uusee.com,*v.iask.com,*vcimg.com,*vizu.com,*wandoujia.com,*wdjimg.com,*web887.com,*wikipedia.org,*williamlong.info,*woniu.com,*wordpress.org,*wrating.com,*wsj.com,*www.renren.com,*xi666.com,*xiachufang.com,*xiami.net,*xiaonei.com,*xilu.com,*xiyou53.com,*xiyou54.com,*xlpan.com,*xmfish.com,*xn--fiqs8s,*xp9365.com,*xtltt.com,*xungou.com,*ydstatic.com,*yieldmanager.com,*yihaodianimg.com,*yintai.com,*yiyi.cc,*ykimg.com,*yocc.net,*youshang.com,*youwo123.com,*zaobao.com,*zaojiao.com,*zbjimg.com,*zdface.com,*zhi.hu,*zhibo8.com,*zhongsou.net,*zx915.com*baidu.com,*qq.com,*taobao.com,*163.com,*weibo.com,*sohu.com,*youku.com,*soso.com,*ifeng.com,*tmall.com,*hao123.com,*tudou.com,*360buy.com,*chinaz.com,*alipay.com,*sogou.com,*renren.com,*cnzz.com,*douban.com,*pengyou.com,*58.com,*alibaba.com,*56.com,*xunlei.com,*bing.com,*iqiyi.com,*csdn.net,*soku.com,*xinhuanet.com,*ku6.com,*aizhan.com,*4399.com,*yesky.com,*soufun.com,*youdao.com,*china.com,*hudong.com,*ganji.com,*kaixin001.com,*paipai.com,*live.com,*alimama.com,*mop.com,*51.la,*51job.com,*dianping.com,*126.com,*admin5.com,*it168.com,*2345.com,*huanqiu.com,*arpg2.com,*777wyx.com,*chinanews.com,*letv.com,*jiayuan.com,*39.net,*twcczhu.com,*cnblogs.com,*microsoft.com,*dangdang.com,*pchome.net,*pptv.com,*vancl.com,*zhaopin.com,*apple.com,*bitauto.com,*etao.com,*qunar.com,*eastmoney.com,*yihaodian.com,*115.com,*21cn.com,*blog.163.com,*hupu.com,*duowan.com,*52pk.net,*baixing.com,*iteye.com,*verycd.com,*suning.com,*discuz.net,*7k7k.com,*mtime.com,*msn.com,*ccb.com,*hc360.com,*cmbchina.com,*51.com,*yoka.com,*seowhy.com,*chinabyte.com,*qidian.com,*ctrip.com,*cnbeta.com,*tom.com,*tenpay.com,*meituan.com,*120ask.com,*ebay.com,*51cto.com,*sdo.com,*meilishuo.com,*17173.com,*xyxy.net,*19lou.com,*yiqifa.com,*nuomi.com,*eastday.com,*onlinedown.net,*oschina.net,*zhubajie.com,*amazon.com,*babytree.com,*kdnet.net,*docin.com,*qq937.com,*tgbus.com,*51buy.com,*nipic.com,*im286.com,*baomihua.com,*doubleclick.com,*dh818.com,*ads8.com,*hiapk.com,*ynet.com,*sootoo.com,*mogujie.com,*gfan.com,*ppstream.com,*a135.net,*ip138.com,*zx915.com,*lashou.com,*crsky.com,*iciba.com,*uuzu.com,*tuan800.com,*haodf.com,*youboy.com,*ulink.cc,*qiyou.com,*88db.com,*tao123.com,*178.com,*ci123.com,*yolk7.com,*tiexue.net,*stockstar.com,*xici.net,*pcpop.com,*linkedin.com,*weiphone.com,*doc88.com,*adobe.com,*shangdu.com,*aili.com,*anjuke.com,*360doc.com,*cnxad.com,*west263.com,*jiathis.com,*gougou.com,*whlongda.com,*mnwan.com,*onetad.com,*duote.com,*55bbs.com,*iloveyouxi.com,*gongchang.com,*meishichina.com,*qire123.com,*55tuan.com,*cocoren.com,*xiaomi.com,*phpwind.net,*abchina.com,*thethirdmedia.com,*coo8.com,*aliexpress.com,*onlylady.com,*manzuo.com,*elong.com,*aibang.com,*10010.com,*3366.com,*28tui.com,*vipshop.com,*1616.net,*pp.cc,*jumei.com,*tui18.com,*52tlbb.com,*yinyuetai.com,*eye.rs,*baihe.com,*iyaya.com,*imanhua.com,*lusongsong.com,*taobaocdn.com,*leho.com,*315che.com,*donews.com,*cqnews.net,*591hx.com,*114la.com,*gamersky.com,*tangdou.com,*91.com,*uuu9.com,*xinnet.com,*dedecms.com,*cnmo.com,*51fanli.com,*liebiao.com,*yyets.com,*lady8844.com,*newsmth.net,*ucjoy.com,*duba.net,*cnki.net,*70e.com,*funshion.com,*qjy168.com,*paypal.com,*3dmgame.com,*m18.com,*caixin.com,*linezing.com,*53kf.com,*makepolo.com,*dospy.com,*xiami.com,*5173.com,*vjia.com,*hotsales.net,*4738.com,*mydrivers.com,*alisoft.com,*titan24.com,*u17.com,*jb51.net,*diandian.com,*dzwww.com,*hichina.com,*abang.com,*qianlong.com,*m1905.com,*chinahr.com,*zhaodao123.com,*daqi.com,*sourceforge.net,*yaolan.com,*5d6d.net,*fobshanghai.com,*q150.com,*l99.com,*ccidnet.com,*aifang.com,*aol.com,*theplanet.com,*chinaunix.net,*hf365.com,*ad1111.com,*zhihu.com,*blueidea.com,*net114.com,*07073.com,*alivv.com,*mplife.com,*allyes.com,*jqw.com,*netease.com,*1ting.com,*yougou.com,*dbank.com,*made-in-china.com,*36kr.com,*wumii.com,*zoosnet.net,*xitek.com,*ali213.net,*exam8.com,*jxedt.com,*uniontoufang.com,*zqgame.com,*52kmh.com,*yxlady.com,*sznews.com,*longhoo.net,*game3737.com,*51auto.com,*booksky.org,*iqilu.com,*ddmap.com,*cncn.com,*ename.net,*1778.com,*blogchina.com,*778669.com,*dayoo.com,*ct10000.com,*zhibo8.cc,*qingdaonews.com,*zongheng.com,*1o26.com,*oeeee.com,*tiancity.com,*jinti.com,*si.kz,*tuniu.com,*xiu.com,*265.com,*gamestlbb.com,*2hua.com,*moonbasa.com,*sf-express.com,*qiushibaike.com,*ztgame.com,*yupoo.com,*kimiss.com,*cnhubei.com,*pingan.com,*lafaso.com,*rakuten.co.jp,*zhenai.com,*tiao8.info,*7c.com,*tianji.com,*kugou.com,*house365.com,*flickr.com,*xiazaiba.com,*aipai.com,*sodu.org,*bankcomm.com,*lietou.com,*toocle.com,*fengniao.com,*99bill.com,*bendibao.com,*mapbar.com,*nowec.com,*yingjiesheng.com,*comsenz.com,*meilele.com,*otwan.com,*61.com,*meizu.com,*readnovel.com,*fenzhi.com,*up2c.com,*500wan.com,*fx120.net,*ftuan.com,*17u.com,*lehecai.com,*28.com,*bilibili.tv,*huaban.com,*szhome.com,*miercn.com,*fblife.com,*chinaw3.com,*smzdm.com,*b2b168.com,*265g.com,*anzhi.com,*chuangelm.com,*php100.com,*100ye.com,*hefei.cc,*mumayi.com,*sttlbb.com,*mangocity.com,*fantong.com,"];
    
    if (rawExceptions) {
        NSCharacterSet* whites = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSMutableCharacterSet* seps = [NSMutableCharacterSet characterSetWithCharactersInString:@",、"];
        [seps formUnionWithCharacterSet:whites];

        NSArray* exceptions = [rawExceptions componentsSeparatedByCharactersInSet:seps];
        for (NSString* domainOrHost in exceptions) {
            if ([domainOrHost length] > 0) {
                [args addObject:@"-x"];
                [args addObject:domainOrHost];
            }
        }
    }
}

+ (void)addArguments4ManualSpecifyProxyExceptions:(NSMutableArray*) args {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSString* rawExceptions = [defaults stringForKey:@"ProxyExceptions"];
    if (rawExceptions) {
        NSCharacterSet* whites = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSMutableCharacterSet* seps = [NSMutableCharacterSet characterSetWithCharactersInString:@",、"];
        [seps formUnionWithCharacterSet:whites];

        NSArray* exceptions = [rawExceptions componentsSeparatedByCharactersInSet:seps];
        for (NSString* domainOrHost in exceptions) {
            if ([domainOrHost length] > 0) {
                [args addObject:@"-x"];
                [args addObject:domainOrHost];
            }
        }
    }
}

+ (NSString*)getPACFilePath {
    return [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".ShadowsocksX-NG/gfwlist.js"];
}

+ (void)enablePACProxy {
    //start server here and then using the string next line
    //next two lines can open gcdwebserver and work around pac file
    NSString* PACFilePath = [self getPACFilePath];
    [self startPACServer: PACFilePath];
    
    NSURL* url = [NSURL URLWithString: [self getHttpPACUrl]];
    NSLog(@"TTTTTTTTTTT%s:%d someObject=%@", __func__, __LINE__, url);
    NSMutableArray* args = [@[@"--mode", @"auto", @"--pac-url", [url absoluteString]]mutableCopy];
    
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptions:args];
    [self callHelper:args];
}

+ (void)enableGlobalProxy {
    NSString* socks5ListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalSocks5.ListenAddress"];
    NSUInteger port = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalSocks5.ListenPort"];
    
    NSMutableArray* args = [@[@"--mode", @"global", @"--port"
                              , [NSString stringWithFormat:@"%lu", (unsigned long)port],@"--socks-listen-address",socks5ListenAddress]mutableCopy];
    
    // Known issue #106 https://github.com/shadowsocks/ShadowsocksX-NG/issues/106
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTPOn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTP.FollowGlobal"]) {
        NSUInteger privoxyPort = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalHTTP.ListenPort"];
        NSString* privoxyListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalHTTP.ListenAddress"];
        [args addObject:@"--privoxy-port"];
        [args addObject:[NSString stringWithFormat:@"%lu", (unsigned long)privoxyPort]];
        [args addObject:@"--privoxy-listen-address"];
        [args addObject:privoxyListenAddress];
    }
    
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptions:args];
    [self callHelper:args];
    [self stopPACServer];
}

+ (void)enableSmartRouting {
    NSString* socks5ListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalSocks5.ListenAddress"];
    NSUInteger port = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalSocks5.ListenPort"];
    
    NSMutableArray* args = [@[@"--mode", @"global", @"--port"
                              , [NSString stringWithFormat:@"%lu", (unsigned long)port],@"--socks-listen-address",socks5ListenAddress]mutableCopy];
    
    // Known issue #106 https://github.com/shadowsocks/ShadowsocksX-NG/issues/106
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTPOn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTP.FollowGlobal"]) {
        NSUInteger privoxyPort = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalHTTP.ListenPort"];
        NSString* privoxyListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalHTTP.ListenAddress"];
        [args addObject:@"--privoxy-port"];
        [args addObject:[NSString stringWithFormat:@"%lu", (unsigned long)privoxyPort]];
        [args addObject:@"--privoxy-listen-address"];
        [args addObject:privoxyListenAddress];
    }
    
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptionsUserDef:args];
    [self callHelper:args];
    [self stopPACServer];
}

+ (void)disableSmartRouting {
    NSString* socks5ListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalSocks5.ListenAddress"];
    NSUInteger port = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalSocks5.ListenPort"];
    
    NSMutableArray* args = [@[@"--mode", @"global", @"--port"
                              , [NSString stringWithFormat:@"%lu", (unsigned long)port],@"--socks-listen-address",socks5ListenAddress]mutableCopy];
    
    // Known issue #106 https://github.com/shadowsocks/ShadowsocksX-NG/issues/106
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTPOn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"LocalHTTP.FollowGlobal"]) {
        NSUInteger privoxyPort = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalHTTP.ListenPort"];
        NSString* privoxyListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalHTTP.ListenAddress"];
        [args addObject:@"--privoxy-port"];
        [args addObject:[NSString stringWithFormat:@"%lu", (unsigned long)privoxyPort]];
        [args addObject:@"--privoxy-listen-address"];
        [args addObject:privoxyListenAddress];
    }
    
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptions:args];
    [self callHelper:args];
    [self stopPACServer];
}

+ (void)disableProxy {
    // 带上所有参数是为了判断是否原有代理设置是否由ssx-ng设置的。如果是用户手工设置的其他配置，则不进行清空。
    NSURL* url = [NSURL URLWithString: [self getHttpPACUrl]];
    NSString* socks5ListenAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"LocalSocks5.ListenAddress"];
    NSUInteger port = [[NSUserDefaults standardUserDefaults]integerForKey:@"LocalSocks5.ListenPort"];
    
    NSMutableArray* args = [@[@"--mode", @"off"
                              , @"--pac-url", [url absoluteString]
                              , @"--port", [NSString stringWithFormat:@"%lu", (unsigned long)port]
                              , @"--socks-listen-address",socks5ListenAddress
                              ]mutableCopy];
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptions:args];
    [self callHelper:args];
    [self stopPACServer];
}

+ (void)enableExternalPACProxy {
    NSURL* url = [NSURL URLWithString: [self getExternalPACUrl]];
    NSMutableArray* args = [@[@"--mode", @"auto"
                              , @"--pac-url", [url absoluteString]
                              ]mutableCopy];
    [self addArguments4ManualSpecifyNetworkServices:args];
    [self addArguments4ManualSpecifyProxyExceptions:args];
    [self callHelper:args];
    [self stopPACServer];
}

+ (NSString*)getHttpPACUrl {
    NSString * routerPath = @"/proxy.pac";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString * address = [defaults stringForKey:@"PacServer.ListenAddress"];
    int port = (short)[defaults integerForKey:@"PacServer.ListenPort"];
    
    return [NSString stringWithFormat:@"%@%@:%d%@",@"http://",address,port,routerPath];
}

+ (NSString*)getExternalPACUrl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"ExternalPACURL"];
}

+ (void)startPACServer:(NSString*) PACFilePath {
    [self stopPACServer];
    
    NSString * routerPath = @"/proxy.pac";
    
    NSData* originalPACData = [NSData dataWithContentsOfFile:PACFilePath];
    
    webServer = [[GCDWebServer alloc] init];
    

    [webServer addHandlerForMethod:@"GET"
                              path:routerPath
                      requestClass:[GCDWebServerRequest class]
                      processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request)
    {
        GCDWebServerDataResponse* resp = [GCDWebServerDataResponse responseWithData:originalPACData
                                                                        contentType:@"application/x-ns-proxy-autoconfig"];
        
        return resp;
    }
     ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * address = [defaults stringForKey:@"PacServer.ListenAddress"];
    int port = (short)[defaults integerForKey:@"PacServer.ListenPort"];
    
    [webServer startWithOptions:@{@"ServerName":address,@"Port":@(port)} error:nil];
}

+ (void)stopPACServer {
    //原版似乎没有处理这个，本来设计计划如果切换到全局模式或者手动模式就关掉webserver 似乎没有这个必要了？
    if ([webServer isRunning]) {
        [webServer stop];
    }
}

+ (void)startMonitorPAC {
    // Monitor change event of the PAC file.
    NSString* PACFilePath = [self getPACFilePath];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    int fileId = open([PACFilePath UTF8String], O_EVTONLY);
    __block dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileId,
                                                              DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE,
                                                              queue);
    dispatch_source_set_event_handler(source, ^
                                      {
                                          unsigned long flags = dispatch_source_get_data(source);
                                          if(flags & DISPATCH_VNODE_DELETE)
                                          {
                                              dispatch_source_cancel(source);
                                          }
                                          
                                          // The PAC file was written by atomically (PACUtils.swift:134)
                                          // That means DISPATCH_VNODE_DELETE event always be trigged
                                          // Need to be run the following statements in any events
                                          NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                          if ([defaults boolForKey:@"ShadowsocksOn"]) {
                                              if ([[defaults stringForKey:@"ShadowsocksRunningMode"] isEqualToString:@"auto"]) {
                                                  [ProxyConfHelper disableProxy];
                                                  [ProxyConfHelper enablePACProxy];
                                              }
                                          }
                                      });
    dispatch_source_set_cancel_handler(source, ^(void) 
                                       {
                                           close(fileId);
                                       });
    dispatch_resume(source);
}

@end

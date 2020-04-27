import 'dart:convert';

import 'package:flutter_app/splash.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class DataSource{
  void fetchAll() async{
    fetchnews();
    fetchData();
    fetchworld();
    fetchhelpline();
    fetchnews();
    fetchData();
  }
  fetchData() async {
//    setState(() {
//      isLoading = true;
//    });

    final Response response = await get("https://api.covid19india.org/data.json");
    final Response response2 = await get("https://api.covid19india.org/v2/state_district_wise.json");
    final Response response3 = await get("https://api.covid19india.org/raw_data.json");
    // final Response helpno = await get("https://covidout.in/helpline");
    if (response.statusCode == 200 && response2.statusCode == 200) {
      states = List();
      stateDeath = List();
      stateData = List();
      stateRecov = List();
      dates = List();
      days = List();
      datecases = List();
      datetotcase = List();
      datedeath = List();
      daterecov = List();
      datetotdeath = List();
      datetotrecov = List();

//      indAllData = List();

      var data = response.body;
      var inddata = jsonDecode(data);

      var data2 = response2.body;
      distdata=jsonDecode(data2);
      indiaData = inddata;

      var data3 = response3.body;
      var rawdata = jsonDecode(data3);

//      print(inddata['statewise'][0]['active']);
      lastupdatetime = inddata['statewise'][0]['lastupdatedtime'];
      tcaseind = int.parse(inddata['statewise'][0]['confirmed']);
      newtcaseind =  int.parse(inddata['statewise'][0]['deltaconfirmed']);
      actcaseind = int.parse(inddata['statewise'][0]['active']);
      deathind = int.parse(inddata['statewise'][0]['deaths']);
      recovind = int.parse(inddata['statewise'][0]['recovered']);
      newdeathind = int.parse(inddata['statewise'][0]['deltadeaths']);
      newrecovind = int.parse(inddata['statewise'][0]['deltarecovered']);
      for(var i in inddata['statewise'])
      {
        states.add(i['state']);
        stateData.add(i['confirmed']);
        stateDeath.add(i['deaths']);
        stateRecov.add(i['recovered']);
        newstateData.add(i['deltaconfirmed']);
        newstateDeath.add(i['deltadeaths']);
        newstateRecov.add(i['deltarecovered']);
      }
      day=0;
      for(var i in inddata['cases_time_series'])
      {
        int mm=0;
        int dd=int.parse(i['date'].toString().split(' ')[0]);
        String x = i['date'].toString().split(' ')[1].toLowerCase();
        x == 'january'?mm=01:x=='february'?mm=02:x=='march'?mm=03:x=='april'?mm=04:x=='may'?mm=05:x=='june'?mm=06:
        x=='july'?mm=07:x=='august'?mm=08:x=='september'?mm=09:x=='october'?mm=10:x=='november'?mm=11:mm=12;
        dates.add('$mm${i['date'].toString().split(' ')[0]}');
        days.add(day);
        datecases.add(i['dailyconfirmed']);
        datetotcase.add(i['totalconfirmed']);
        datedeath.add(i['dailydeceased']);
        datetotdeath.add(i['totaldeceased']);
        daterecov.add(i['dailyrecovered']);
        datetotrecov.add(i['totalrecovered']);
        day++;
      }
      print(day);
//      print(rawdata['raw_data'][0]);
      one=0;two=0;three=0;four=0;five=0;
      for(var i in rawdata['raw_data'])
      {
        if(i['gender']=='F')
          female++;
        else if(i['gender']=='M')
          male++;
        if(i['agebracket'] != '') {
          var x= int.parse(i['agebracket']);
          x>0&&x<20?one++:x<40?two++:x<60?three++:x<80?four++:five++;
          age.add(i['agebracket']);
        }
      }
      var totalgender = male+female;
      male = (male*100/totalgender) as int;
      female = (female*100/totalgender) as int;
//      print(male+female);

//      List<Map<String,String>>
//      distdata[dropdownvalue]['districtData'][i]
//      List<Map<String,dynamic>> indDataMap =[
//        {'overall':inddata['statewise'][0],
//          'statewise':[
//            for(int i=1;i< states.length;i++){
//              'state': states[i],
//              'confirmed': stateData[i],
//              'death': stateDeath[i],
//              'recovered': stateRecov[i],
//              'newconfirmed': newstateData[i],
//              'newdeath': newstateDeath[i],
//              'newrecovered': newstateRecov[i],
////              'districtdata': stateData[i]=='0'?null:stdata['${states[i].toString()}']['districtData'],
//            },
//          ],
//          'districtwisedata': stdata,
//          'timewisedata':inddata['cases_time_series'],
//        },
//      ];
//      var encode = json.encode(indDataMap.toString());
//      indAllData = jsonDecode(encode);
//      print(indAllData);
//      print(indAllData[0]['overall']);
//      print(states[1]);
//      print(stdata['${states[1].toString()}']['districtData']);

//      setState(() {
//        print('india data fetched');
//        isLoading = false;
//      });
    } else {
      throw Exception('Failed to load');
    }
  }
  fetchnews() async {
//    setState(() {
//      isLoading = true;
//    });

    final Response response = await get("https://indianexpress.com/about/coronavirus/");
    if (response.statusCode == 200) {
      newsAllData = List();
      var data = response.body;
      var document = parse(response.body);
      List links = document.querySelectorAll('h3 > a');
      List<Map<String, dynamic>> linkMap = [];
      // print(linkMap);
      for (var link in links) {
        linkMap.add({
          'title': link.text,
          'link': link.attributes['href'],
        });
      }
      newslink = List();
      newslist = List();
      var enc = json.encode(linkMap);
      List newsdata = jsonDecode(enc);
      newsData = newsdata;
      for (var i = 0; i < newsdata.length; i++) {
        newslist.add(newsdata[i]['title']);
        newslink.add(newsdata[i]['link']);
      }

      List links2 = document.querySelectorAll('div > p');
      List<Map<String, String>> linkMap2 = [];
      // print(linkMap);
      for (var link in links2) {
        linkMap2.add({
          'title': link.text,
        });
      }
      var enc2 = json.encode(linkMap2);
      List newsdata2 = jsonDecode(enc2);
      for (var i = 0; i < newsdata.length; i+=2) {
        newsdate.add(newsdata2[i]['title']);
        newssubhead.add(newsdata2[i+1]['title']);
      }

      List links3 = document.querySelectorAll('div.details > div.about-thumb > a > noscript ');
      List img = [];
      for(var link in links3) {
        String x = link.text;
//        print(x);
        if(x.contains('class'))
          img.add(x.substring(x.indexOf('src')+5,x.indexOf('class')-2));
        else
          img.add(null);
      }
//      print(img);

      List<Map<String,String>> newsMap = [];
      for(int i=0;i<newsdata.length;i++)
        newsMap.add({
          'title': newslist[i],
          'link': newslink[i],
          'date': newsdate[i],
          'info': newssubhead[i],
          'image': img[i],
        });
      var encodeNews = json.encode(newsMap);
      newsAllData = jsonDecode(encodeNews);
//      print(newsAllData);
//      if(newsAllData.length!=0)

//      setState(() {
//        print('news fetched');
//        isLoading = false;
//      });
    } else {
      throw Exception('Failed to load');
    }
  }

  fetchworld() async {
//    setState(() {
//      isLoading = true;
//    });
    final Response resp = await get("https://corona.lmao.ninja/v2/all?yesterday=true");
    if(resp.statusCode==200){
      var data = resp.body;
      var wld = jsonDecode(data);
      world = wld;
    }
    final Response resp2 = await get("https://corona.lmao.ninja/v2/continents?yesterday=true&sort=cases");
    if(resp2.statusCode==200){
      var data = resp2.body;
      var continentData = jsonDecode(data);
      continent = continentData;
    }
    final Response response = await get("https://www.worldometers.info/coronavirus/");
    if (response.statusCode == 200) {
      var data = response.body;
      var document = parse(response.body);
      List links = document.querySelectorAll('#maincounter-wrap > div > span');
      List<Map<String, dynamic>> linkMap = [];
      for (var link in links) {
        linkMap.add({
          'title': link.text,
        });
      }
      var enc = json.encode(linkMap);
      List worlddata = jsonDecode(enc);
      worldData = worlddata;
      List linkcont = document.querySelectorAll(
          'tr');
      List<Map<String, dynamic>> linkMap2 = [];
      for (var link in linkcont) {
//        if(link%12!=0)
//          link++;
        linkMap2.add({
          'title': link.text.toString().split('\n')[1],
          'cases': link.text.toString().split('\n')[2],
          'newcase': link.text.toString().split('\n')[3],
          'deaths': link.text.toString().split('\n')[4],
          'newdeath':link.text.toString().split('\n')[5],
          'recovered': link.text.toString().split('\n')[6],
//           'activecase':link.text,
//           'serious':link.text,
//           'cases/1M':link.text,
//           'death/1M': link.text,
//           'tests':link.text,
//           'tests/1M':link.text,
        });
      }
      var enc2 = json.encode(linkMap2);
      List contname = jsonDecode(enc2);
//       newtcasewld = contname[1]['newcase'];
//       newdeathwld = contname[1]['newdeath'];
      for(var i in contname) {
        contries.add(i['title']);
        casescont.add(i['cases']);
        newcasecont.add(i['newcase']);
        deathcont.add(i['deaths']);
        newdeathcont.add(i['newdeath']);
        recovercont.add(i['recovered']);
      }
//       print(contries[3]);
//       print(contname);
//      setState(() {
//        print('helpline fetched');
//        isLoading = false;
//      });
    } else {
//      loadfailed = true;
      Exception('Failed to load');
    }
  }

  fetchhelpline() async {
//    setState(() {
//      isLoading = true;
//    });

    final Response response = await get("https://api.rootnet.in/covid19-in/contacts");
    if (response.statusCode == 200) {
      state = List();phone = List();
      var list = json.decode(response.body) ;
//      print(list['data']);

      for (var stats in list['data']['contacts']['regional']) {
        state.add(stats['loc']);//+' : '+stats['']);
        phone.add(stats['number']);
        // stateDeath.add(stats['deaths']);
      }

//      setState(() {
//        print('world data fetched');
//        isLoading = false;
//      });
    } else {
      throw Exception('Failed to load');
    }
  }


}
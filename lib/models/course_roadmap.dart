// Copyright (C) 2026 Daily You TH3 Learning English
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/models/study_sentence.dart';
import 'package:flutter/material.dart';

/// Đại diện cho một Cấp độ trong Khung tham chiếu Châu Âu (CEFR: A1 -> C2)
class CourseLevel {
  final String code; // 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'
  final String title;
  final String subtitle;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final List<CourseLesson> lessons;

  const CourseLevel({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.lessons,
  });

  int get totalSentences =>
      lessons.fold(0, (sum, lesson) => sum + lesson.sentences.length);
}

/// Đại diện cho một Bài học (Unit) trong một Cấp độ
class CourseLesson {
  final String id;
  final String levelCode;
  final int unitNumber;
  final String title;
  final String topic;
  final String description;
  final IconData icon;
  final List<StudySentence> sentences;

  const CourseLesson({
    required this.id,
    required this.levelCode,
    required this.unitNumber,
    required this.title,
    required this.topic,
    required this.description,
    required this.icon,
    required this.sentences,
  });
}

/// Kho dữ liệu Lộ trình học 6 Cấp độ (A1 -> C2), mỗi cấp độ 10 bài học, mỗi bài 6-20 câu.
class CourseRoadmapRepository {
  static final List<CourseLevel> allLevels = [
    _levelA1,
    _levelA2,
    _levelB1,
    _levelB2,
    _levelC1,
    _levelC2,
  ];

  static CourseLevel? getLevel(String code) {
    try {
      return allLevels.firstWhere(
        (l) => l.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // LEVEL A1: BEGINNER (MỚI BẮT ĐẦU)
  // ===========================================================================
  static final CourseLevel _levelA1 = CourseLevel(
    code: 'A1',
    title: 'Level A1 - Beginner',
    subtitle: 'Mới bắt đầu & Làm quen',
    description: 'Nền tảng giao tiếp căn bản, phát âm chuẩn các câu chào hỏi, số đếm, gia đình và thói quen sinh hoạt.',
    primaryColor: const Color(0xFF4CAF50), // Xanh lá năng động
    secondaryColor: const Color(0xFFE8F5E9),
    icon: Icons.eco_rounded,
    lessons: [
      _createLesson('A1', 1, 'Chào hỏi & Làm quen', 'daily', Icons.waving_hand_rounded, 'Luyện phát âm các câu chào hỏi lịch sự hàng ngày.', [
        _s('Hello, nice to meet you!', 'Xin chào, rất vui được gặp bạn!', '/həˈləʊ naɪs tuː miːt juː/'),
        _s('Good morning, how are you today?', 'Chào buổi sáng, hôm nay bạn thế nào?', '/ɡʊd ˈmɔː.nɪŋ haʊ ɑː juː təˈdeɪ/'),
        _s('I am doing great, thank you!', 'Tôi đang rất ổn, cảm ơn bạn!', '/aɪ æm ˈduː.ɪŋ ɡreɪt θæŋk juː/'),
        _s('What is your name?', 'Tên của bạn là gì?', '/wɒt ɪz jɔː neɪm/'),
        _s('My name is David, from Vietnam.', 'Tên tôi là David, đến từ Việt Nam.', '/maɪ neɪm ɪz ˈdeɪvɪd frɒm ˌvjɛtˈnæm/'),
        _s('Have a wonderful day ahead!', 'Chúc bạn một ngày tuyệt vời phía trước!', '/hæv ə ˈwʌn.də.fəl deɪ əˈhɛd/'),
      ]),
      _createLesson('A1', 2, 'Gia đình & Bản thân', 'daily', Icons.people_rounded, 'Mô tả các thành viên trong gia đình và nghề nghiệp.', [
        _s('There are four people in my family.', 'Có bốn người trong gia đình tôi.', '/ðeər ɑː fɔː ˈpiː.pəl ɪn maɪ ˈfæm.ɪ.li/'),
        _s('My father is a teacher.', 'Bố tôi là một giáo viên.', '/maɪ ˈfɑː.ðər ɪz ə ˈtiː.tʃər/'),
        _s('My mother cooks delicious food.', 'Mẹ tôi nấu ăn rất ngon.', '/maɪ ˈmʌð.ər kʊks dɪˈlɪʃ.əs fuːd/'),
        _s('I have an older brother.', 'Tôi có một người anh trai.', '/aɪ hæv ən ˈəʊl.dər ˈbrʌð.ər/'),
        _s('We love spending weekends together.', 'Chúng tôi thích dành ngày cuối tuần cùng nhau.', '/wiː lʌv ˈspɛn.dɪŋ ˌwiːkˈɛndz təˈɡɛð.ər/'),
        _s('I am proud of my family.', 'Tôi rất tự hào về gia đình mình.', '/aɪ æm praʊd ɒv maɪ ˈfæm.ɪ.li/'),
      ]),
      _createLesson('A1', 3, 'Số đếm, Giờ giấc & Ngày tháng', 'daily', Icons.access_time_rounded, 'Hỏi và trả lời giờ giấc, ngày tháng chuẩn xác.', [
        _s('Excuse me, what time is it now?', 'Xin lỗi, bây giờ là mấy giờ rồi?', '/ɪkˈskjuːz miː wɒt taɪm ɪz ɪt naʊ/'),
        _s('It is half past seven in the morning.', 'Bây giờ là bảy rưỡi sáng.', '/ɪt ɪz hɑːf pɑːst ˈsɛv.ən ɪn ðə ˈmɔː.nɪŋ/'),
        _s('Today is Monday, November fourth.', 'Hôm nay là thứ Hai, ngày 4 tháng 11.', '/təˈdeɪ ɪz ˈmʌn.deɪ nəʊˈvɛm.bər fɔːθ/'),
        _s('The class begins at eight o clock.', 'Lớp học bắt đầu lúc tám giờ đúng.', '/ðə klɑːs bɪˈɡɪnz æt eɪt əˈklɒk/'),
        _s('See you again tomorrow afternoon.', 'Hẹn gặp lại bạn vào chiều mai nhé.', '/siː juː əˈɡɛn təˈmɒr.əʊ ˌɑːf.təˈnuːn/'),
        _s('Time flies when we are having fun.', 'Thời gian trôi thật nhanh khi vui vẻ.', '/taɪm flaɪz wɛn wiː ɑː ˈhæv.ɪŋ fʌn/'),
      ]),
      _createLesson('A1', 4, 'Ăn uống cơ bản', 'dining', Icons.restaurant_rounded, 'Giao tiếp gọi món tại quán ăn và đồ uống yêu thích.', [
        _s('Can I have a cup of coffee, please?', 'Cho tôi một tách cà phê được không?', '/kæn aɪ hæv ə kʌp ɒv ˈkɒf.i pliːz/'),
        _s('I would like a glass of water.', 'Tôi muốn một ly nước lọc.', '/aɪ wʊd laɪk ə ɡlɑːs ɒv ˈwɔː.tər/'),
        _s('This orange juice is very fresh.', 'Nước cam này rất tươi ngon.', '/ðɪs ˈɒr.ɪndʒ dʒuːs ɪz ˈvɛr.i frɛʃ/'),
        _s('Do you have hot tea?', 'Bạn có trà nóng không?', '/duː juː hæv hɒt tiː/'),
        _s('The bread tastes really crisp.', 'Bánh mì có vị rất giòn.', '/ðə brɛd teɪsts ˈrɪə.li krɪsp/'),
        _s('Thank you for the delicious breakfast.', 'Cảm ơn bạn vì bữa sáng ngon miệng.', '/θæŋk juː fɔː ðə dɪˈlɪʃ.əs ˈbrɛk.fəst/'),
      ]),
      _createLesson('A1', 5, 'Nhà cửa & Đồ đạc', 'daily', Icons.home_rounded, 'Mô tả phòng ở và các vật dụng thường nhật.', [
        _s('My bedroom is bright and clean.', 'Phòng ngủ của tôi sáng sủa và sạch sẽ.', '/maɪ ˈbɛd.ruːm ɪz braɪt ænd kliːn/'),
        _s('The laptop is on the wooden table.', 'Chiếc máy tính xách tay ở trên bàn gỗ.', '/ðə ˈlæp.tɒp ɪz ɒn ðə ˈwʊd.ən ˈteɪ.bəl/'),
        _s('Please close the window before leaving.', 'Làm ơn đóng cửa sổ trước khi rời đi.', '/pliːz kləʊz ðə ˈwɪn.dəʊ bɪˈfɔː ˈliː.vɪŋ/'),
        _s('I love reading books in my living room.', 'Tôi thích đọc sách trong phòng khách.', '/aɪ lʌv ˈriː.dɪŋ bʊks ɪn maɪ ˈlɪv.ɪŋ ruːm/'),
        _s('Turn on the lamp, please.', 'Làm ơn bật chiếc đèn lên.', '/tɜːn ɒn ðə læmp pliːz/'),
        _s('Everything is in its right place.', 'Mọi thứ đều ở đúng vị trí của nó.', '/ˈɛv.rɪ.θɪŋ ɪz ɪn ɪts raɪt pleɪs/'),
      ]),
      _createLesson('A1', 6, 'Màu sắc & Quần áo', 'daily', Icons.palette_rounded, 'Miêu tả trang phục và màu sắc ưa thích.', [
        _s('I am wearing a blue jacket today.', 'Hôm nay tôi mặc một chiếc áo khoác xanh.', '/aɪ æm ˈweə.rɪŋ ə bluː ˈdʒæk.ɪt təˈdeɪ/'),
        _s('Her dress looks elegant and bright.', 'Chiếc váy của cô ấy trông thanh lịch và sáng.', '/hɜː drɛs lʊks ˈɛl.ɪ.ɡənt ænd braɪt/'),
        _s('Which color do you like best?', 'Bạn thích màu sắc nào nhất?', '/wɪtʃ ˈkʌl.ər duː juː laɪk bɛst/'),
        _s('These black shoes fit me comfortably.', 'Đôi giày đen này vừa vặn rất êm.', '/ðiːz blæk ʃuːz fɪt miː ˈkʌm.fə.tə.bli/'),
        _s('White shirts are always stylish.', 'Áo sơ mi trắng luôn luôn phong cách.', '/waɪt ʃɜːts ɑː ˈɔːl.weɪz ˈstaɪ.lɪʃ/'),
        _s('Put on your warm coat, it is chilly.', 'Mặc áo ấm vào nhé, trời se lạnh đấy.', '/pʊt ɒn jɔː wɔːm kəʊt ɪt ɪz ˈtʃɪl.i/'),
      ]),
      _createLesson('A1', 7, 'Sở thích & Thể thao', 'daily', Icons.sports_soccer_rounded, 'Nói về những điều bạn thích làm khi rảnh rỗi.', [
        _s('I enjoy listening to acoustic music.', 'Tôi thích nghe nhạc mộc acoustic.', '/aɪ ɪnˈdʒɔɪ ˈlɪs.ən.ɪŋ tuː əˈkuː.stɪk ˈmjuː.zɪk/'),
        _s('Do you like playing badminton?', 'Bạn có thích chơi cầu lông không?', '/duː juː laɪk ˈpleɪ.ɪŋ ˈbæd.mɪn.tən/'),
        _s('Swimming helps me stay healthy.', 'Bơi lội giúp tôi duy trì sức khỏe.', '/ˈswɪm.ɪŋ hɛlps miː steɪ ˈhɛl.θi/'),
        _s('She plays the piano very well.', 'Cô ấy chơi đàn dương cầm rất giỏi.', '/ʃiː pleɪz ðə piˈæn.əʊ ˈvɛr.i wɛl/'),
        _s('Let us go for a walk in the park.', 'Chúng ta cùng đi dạo trong công viên nhé.', '/lɛt ʌs ɡəʊ fɔːr ə wɔːk ɪn ðə pɑːk/'),
        _s('Outdoor activities bring positive energy.', 'Hoạt động ngoài trời mang lại năng lượng tích cực.', '/ˌaʊtˈdɔːr ækˈtɪv.ɪ.tiz brɪŋ ˈpɒz.ə.tɪv ˈɛn.ə.dʒi/'),
      ]),
      _createLesson('A1', 8, 'Hỏi thăm sức khỏe', 'daily', Icons.favorite_rounded, 'Biết cách thăm hỏi và diễn đạt cảm giác của bản thân.', [
        _s('Are you feeling well today?', 'Hôm nay bạn có cảm thấy khỏe không?', '/ɑː juː ˈfiː.lɪŋ wɛl təˈdeɪ/'),
        _s('I have a slight headache.', 'Tôi bị hơi đau đầu một chút.', '/aɪ hæv ə slaɪt ˈhɛd.eɪk/'),
        _s('You should drink warm water and rest.', 'Bạn nên uống nước ấm và nghỉ ngơi.', '/juː ʃʊd drɪŋk wɔːm ˈwɔː.tər ænd rɛst/'),
        _s('Take care of yourself!', 'Hãy tự chăm sóc bản thân thật tốt nhé!', '/teɪk keər ɒv jɔːˈsɛlf/'),
        _s('I feel energetic after a good sleep.', 'Tôi thấy tràn đầy năng lượng sau giấc ngủ ngon.', '/aɪ fiːl ˌɛn.əˈdʒɛt.ɪk ˈɑːf.tər ə ɡʊd sliːp/'),
        _s('Health is our greatest treasure.', 'Sức khỏe là tài sản quý giá nhất.', '/hɛlθ ɪz ˈaʊə ˈɡreɪ.tɪst ˈtrɛʒ.ər/'),
      ]),
      _createLesson('A1', 9, 'Động vật & Thiên nhiên', 'daily', Icons.pets_rounded, 'Mô tả thú cưng và cảnh quan xung quanh.', [
        _s('I have a cute golden puppy.', 'Tôi có một chú cún con lông vàng đáng yêu.', '/aɪ hæv ə kjuːt ˈɡəʊl.dən ˈpʌp.i/'),
        _s('The birds are singing outside.', 'Những chú chim đang hót líu lo bên ngoài.', '/ðə bɜːdz ɑː ˈsɪŋ.ɪŋ ˌaʊtˈsaɪd/'),
        _s('The weather is sunny and breezy.', 'Thời tiết nắng ráo và có gió nhẹ dễ chịu.', '/ðə ˈwɛð.ər ɪz ˈsʌn.i ænd ˈbriː.zi/'),
        _s('Look at the beautiful green trees.', 'Hãy nhìn những hàng cây xanh mướt tuyệt đẹp.', '/lʊk æt ðə ˈbjuː.tɪ.fəl ɡriːn triːz/'),
        _s('Cats love sleeping in the sun.', 'Mèo rất thích nằm ngủ dưới ánh nắng.', '/kæts lʌv ˈsliː.pɪŋ ɪn ðə sʌn/'),
        _s('Nature gives us peaceful moments.', 'Thiên nhiên mang lại cho ta những khoảnh khắc bình yên.', '/ˈneɪ.tʃər ɡɪvz ʌs ˈpiːs.fəl ˈməʊ.mənts/'),
      ]),
      _createLesson('A1', 10, 'Tự tin phát âm phản xạ', 'daily', Icons.auto_awesome_rounded, 'Ôn tập tổng kết và tăng tốc độ phản xạ giao tiếp.', [
        _s('Practice makes perfect.', 'Có công mài sắt, có ngày nên kim.', '/ˈpræk.tɪs meɪks ˈpɜː.fɪkt/'),
        _s('I can speak English with confidence.', 'Tôi có thể nói tiếng Anh đầy tự tin.', '/aɪ kæn spiːk ˈɪŋ.ɡlɪʃ wɪð ˈkɒn.fɪ.dəns/'),
        _s('Learning English step by step is fun.', 'Học tiếng Anh từng bước một thật thú vị.', '/ˈlɜː.nɪŋ ˈɪŋ.ɡlɪʃ stɛp baɪ stɛp ɪz fʌn/'),
        _s('Keep up the good effort every day!', 'Hãy duy trì sự cố gắng mỗi ngày nhé!', '/kiːp ʌp ðə ɡʊd ˈɛf.ət ˈɛv.ri deɪ/'),
        _s('Believe in yourself and you will succeed.', 'Hãy tin vào bản thân và bạn sẽ thành công.', '/bɪˈliːv ɪn jɔːˈsɛlf ænd juː wɪl səkˈsiːd/'),
        _s('I am ready for the next level!', 'Tôi đã sẵn sàng cho cấp độ tiếp theo!', '/aɪ æm ˈrɛd.i fɔː ðə nɛkst ˈlɛv.əl/'),
      ]),
      _createLesson('A1', 11, 'Thành ngữ & Tục ngữ thông dụng', 'idioms', Icons.format_quote_rounded, 'Khám phá các câu thành ngữ và châm ngôn phổ biến nhất.', [
        _s('Better late than never.', 'Muộn còn hơn không bao giờ đến.', '/ˈbɛt.ər leɪt ðæn ˈnɛv.ər/'),
        _s('Actions speak louder than words.', 'Hành động có giá trị hơn vạn lời nói.', '/ˈæk.ʃənz spiːk ˈlaʊ.dər ðæn wɜːdz/'),
        _s('A piece of cake.', 'Dễ như trở bàn tay.', '/ə piːs ɒv keɪk/'),
        _s('Time is money.', 'Thời gian chính là vàng bạc quý giá.', '/taɪm ɪz ˈmʌn.i/'),
        _s('No pain, no gain.', 'Không chịu khó nhọc thì chẳng có thành công.', '/nəʊ peɪn nəʊ ɡeɪn/'),
        _s('Every cloud has a silver lining.', 'Trong cái rủi bao giờ cũng có cái may.', '/ˈɛv.ri klaʊd hæz ə ˈsɪl.vər ˈlaɪ.nɪŋ/'),
      ]),
    ],
  );

  // ===========================================================================
  // LEVEL A2: ELEMENTARY (SƠ CẤP)
  // ===========================================================================
  static final CourseLevel _levelA2 = CourseLevel(
    code: 'A2',
    title: 'Level A2 - Elementary',
    subtitle: 'Giao tiếp hàng ngày & Sơ cấp',
    description: 'Nâng cao khả năng diễn đạt thông dụng: đi mua sắm, hỏi đường, đặt phòng khách sạn, giao lưu ẩm thực.',
    primaryColor: const Color(0xFF009688), // Teal tươi sáng
    secondaryColor: const Color(0xFFE0F2F1),
    icon: Icons.explore_rounded,
    lessons: [
      _createLesson('A2', 1, 'Hỏi đường & Phương tiện', 'travel', Icons.directions_bus_rounded, 'Hỏi đường, bắt xe buýt, taxi và chỉ dẫn địa điểm.', [
        _s('Excuse me, how can I get to the central station?', 'Xin lỗi, làm sao để tôi đến ga trung tâm?', '/ɪkˈskjuːz miː haʊ kæn aɪ ɡɛt tuː ðə ˈsɛn.trəl ˈsteɪ.ʃən/'),
        _s('Go straight ahead and turn left at the corner.', 'Hãy đi thẳng phía trước rồi rẽ trái ở góc phố.', '/ɡəʊ streɪt əˈhɛd ænd tɜːn lɛft æt ðə ˈkɔː.nər/'),
        _s('Is there a bus stop near here?', 'Có trạm xe buýt nào gần đây không?', '/ɪz ðeər ə bʌs stɒp nɪər hɪər/'),
        _s('Take bus number ten and get off at the third stop.', 'Bắt xe buýt số 10 và xuống ở trạm dừng thứ ba.', '/teɪk bʌs ˈnʌm.bər tɛn ænd ɡɛt ɒf æt ðə θɜːd stɒp/'),
        _s('How long does it take by taxi?', 'Đi bằng taxi mất bao lâu?', '/haʊ lɒŋ dʌz ɪt teɪk baɪ ˈtæk.si/'),
        _s('It is only a five-minute walk from here.', 'Chỉ mất năm phút đi bộ từ đây thôi.', '/ɪt ɪz ˈəʊn.li ə faɪv ˈmɪn.ɪt wɔːk frɒm hɪər/'),
      ]),
      _createLesson('A2', 2, 'Mua sắm & Trả giá', 'travel', Icons.shopping_bag_rounded, 'Hỏi giá tiền, kích cỡ và thanh toán tại cửa hàng.', [
        _s('How much does this cotton shirt cost?', 'Chiếc áo sơ mi cotton này giá bao nhiêu?', '/haʊ mʌtʃ dʌz ðɪs ˈkɒt.ən ʃɜːt kɒst/'),
        _s('Do you have this in a larger size?', 'Bạn có chiếc áo này cỡ lớn hơn không?', '/duː juː hæv ðɪs ɪn ə ˈlɑː.dʒər saɪz/'),
        _s('Can I try it on in the fitting room?', 'Tôi có thể thử chiếc này trong phòng thay đồ được không?', '/kæn aɪ traɪ ɪt ɒn ɪn ðə ˈfɪt.ɪŋ ruːm/'),
        _s('Could you give me a small discount?', 'Bạn có thể giảm giá cho tôi một chút không?', '/kʊd juː ɡɪv miː ə smɔːl ˈdɪs.kaʊnt/'),
        _s('I would like to pay by credit card.', 'Tôi muốn thanh toán bằng thẻ tín dụng.', '/aɪ wʊd laɪk tuː peɪ baɪ ˈkrɛd.ɪt kɑːd/'),
        _s('Here is your receipt and change.', 'Đây là hóa đơn và tiền thừa của bạn.', '/hɪər ɪz jɔː rɪˈsiːt ænd tʃeɪndʒ/'),
      ]),
      _createLesson('A2', 3, 'Tại nhà hàng & Đặt bàn', 'dining', Icons.local_dining_rounded, 'Giao tiếp gọi món, hỏi món đặc sắc và thanh toán.', [
        _s('We would like to book a table for two tonight.', 'Chúng tôi muốn đặt một bàn cho hai người tối nay.', '/wiː wʊd laɪk tuː bʊk ə ˈteɪ.bəl fɔː tuː təˈnaɪt/'),
        _s('What is the chef special dish today?', 'Món đặc sắc hôm nay của bếp trưởng là gì?', '/wɒt ɪz ðə ʃɛf ˈspɛʃ.əl dɪʃ təˈdeɪ/'),
        _s('I am vegetarian, so no meat please.', 'Tôi ăn chay, nên vui lòng không cho thịt.', '/aɪ æm ˌvɛdʒ.ɪˈteə.ri.ən səʊ nəʊ miːt pliːz/'),
        _s('Could we have the bill, please?', 'Làm ơn cho chúng tôi xin hóa đơn tính tiền.', '/kʊd wiː hæv ðə bɪl pliːz/'),
        _s('The food was exquisite and well prepared.', 'Món ăn rất tinh tế và được chế biến chu đáo.', '/ðə fuːd wɒz ˈɛk.skwɪ.zɪt ænd wɛl prɪˈpeəd/'),
        _s('Keep the change, thank you for your service.', 'Cứ giữ lại tiền thừa nhé, cảm ơn sự phục vụ của bạn.', '/kiːp ðə tʃeɪndʒ θæŋk juː fɔː jɔː ˈsɜː.vɪs/'),
      ]),
      _createLesson('A2', 4, 'Khách sạn & Thủ tục nhận phòng', 'travel', Icons.hotel_rounded, 'Check-in, hỏi dịch vụ phòng và tiện ích khách sạn.', [
        _s('I have a reservation under the name Minh.', 'Tôi có một đơn đặt phòng dưới tên Minh.', '/aɪ hæv ə ˌrɛz.əˈveɪ.ʃən ˈʌn.dər ðə neɪm mɪn/'),
        _s('What is the password for the hotel Wi-Fi?', 'Mật khẩu Wi-Fi của khách sạn là gì vậy?', '/wɒt ɪz ðə ˈpɑːs.wɜːd fɔː ðə həʊˈtɛl ˈwaɪ.faɪ/'),
        _s('Is breakfast included in the room price?', 'Bữa sáng đã bao gồm trong giá phòng chưa?', '/ɪz ˈbrɛk.fəst ɪnˈkluː.dɪd ɪn ðə ruːm praɪs/'),
        _s('What time is check-out tomorrow?', 'Mấy giờ ngày mai là hạn trả phòng?', '/wɒt taɪm ɪz ˈtʃɛk.aʊt təˈmɒr.əʊ/'),
        _s('Could you send fresh towels to room 302?', 'Làm ơn gửi khăn tắm mới lên phòng 302 giúp tôi.', '/kʊd juː sɛnd frɛʃ ˈtaʊ.əlz tuː ruːm θriː əʊ tuː/'),
        _s('The sea view from this balcony is breathtaking.', 'Góc nhìn ra biển từ ban công này đẹp nghẹt thở.', '/ðə siː vjuː frɒm ðɪs ˈbæl.kə.ni ɪz ˈbrɛθˌteɪ.kɪŋ/'),
      ]),
      _createLesson('A2', 5, 'Thời tiết & Trang phục mùa vụ', 'daily', Icons.cloud_rounded, 'Nói về dự báo thời tiết và chuẩn bị đồ đạc.', [
        _s('The forecast says it will rain this afternoon.', 'Dự báo nói rằng chiều nay trời sẽ mưa.', '/ðə ˈfɔː.kɑːst sɛz ɪt wɪl reɪn ðɪs ˌɑːf.təˈnuːn/'),
        _s('Do not forget to take an umbrella with you.', 'Đừng quên mang theo một chiếc ô bên mình nhé.', '/duː nɒt fəˈɡɛt tuː teɪk ən ʌmˈbrɛl.ə wɪð juː/'),
        _s('Autumn in Hanoi is pleasantly cool and breezy.', 'Mùa thu ở Hà Nội mát mẻ dễ chịu và gió nhẹ.', '/ˈɔː.təm ɪn hæˈnɔɪ ɪz ˈplɛz.ənt.li kuːl ænd ˈbriː.zi/'),
        _s('The temperature dropped to fifteen degrees.', 'Nhiệt độ đã giảm xuống còn mười lăm độ C.', '/ðə ˈtɛm.prə.tʃər drɒpt tuː ˈfɪf.tiːn dɪˈɡriːz/'),
        _s('A warm sweater is essential for winter.', 'Một chiếc áo len ấm là vật dụng thiết yếu cho mùa đông.', '/ə wɔːm ˈswɛt.ər ɪz ɪˈsɛn.ʃəl fɔː ˈwɪn.tər/'),
        _s('The sunny sky makes me feel inspired.', 'Bầu trời rực nắng khiến tôi cảm thấy tràn đầy cảm hứng.', '/ðə ˈsʌn.i skaɪ meɪks miː fiːl ɪnˈspaɪəd/'),
      ]),
      _createLesson('A2', 6, 'Kể về kỳ nghỉ cuối tuần', 'daily', Icons.beach_access_rounded, 'Diễn tả các hoạt động thư giãn và trải nghiệm đã qua.', [
        _s('Last weekend I visited my grandparents countryside.', 'Cuối tuần trước tôi đã về thăm quê ông bà.', '/lɑːst ˌwiːkˈɛnd aɪ ˈvɪz.ɪ.tɪd maɪ ˈɡræn.peə.rənts ˈkʌn.tri.saɪd/'),
        _s('We had a wonderful picnic by the peaceful lake.', 'Chúng tôi đã có một buổi dã ngoại tuyệt vời bên hồ nước yên bình.', '/wiː hæd ə ˈwʌn.də.fəl ˈpɪk.nɪk baɪ ðə ˈpiːs.fəl leɪk/'),
        _s('I took lots of memorable photos with friends.', 'Tôi đã chụp rất nhiều bức ảnh đáng nhớ cùng bạn bè.', '/aɪ tʊk lɒts ɒv ˈmɛm.ər.ə.bəl ˈfəʊ.təʊz wɪð frɛndz/'),
        _s('Cooking dinner together was so much fun.', 'Cùng nhau nấu bữa tối vui vẻ vô cùng.', '/ˈkʊk.ɪŋ ˈdɪn.ər təˈɡɛð.ər wɒz səʊ mʌtʃ fʌn/'),
        _s('I felt totally recharged and happy.', 'Tôi cảm thấy được sạc đầy năng lượng và rất vui.', '/aɪ fɛlt ˈtəʊ.təl.i ˌriːˈtʃɑːdʒd ænd ˈhæp.i/'),
        _s('I look forward to our next camping trip.', 'Tôi rất mong chờ chuyến đi cắm trại tiếp theo của chúng ta.', '/aɪ lʊk ˈfɔː.wəd tuː ˈaʊə nɛkst ˈkæm.pɪŋ trɪp/'),
      ]),
      _createLesson('A2', 7, 'Đi khám bệnh & Mua thuốc', 'daily', Icons.local_hospital_rounded, 'Mô tả triệu chứng bệnh và hỏi cách dùng thuốc.', [
        _s('I have a sore throat and a slight fever.', 'Tôi bị đau rát họng và hơi sốt một chút.', '/aɪ hæv ə sɔː θrəʊt ænd ə slaɪt ˈfiː.vər/'),
        _s('How many times a day should I take this medicine?', 'Mỗi ngày tôi nên uống thuốc này mấy lần?', '/haʊ ˈmɛn.i taɪmz ə deɪ ʃʊd aɪ teɪk ðɪs ˈmɛd.sən/'),
        _s('Take one pill after meals with warm water.', 'Uống một viên sau bữa ăn cùng nước ấm.', '/teɪk wʌn pɪl ˈɑːf.tər miːlz wɪð wɔːm ˈwɔː.tər/'),
        _s('You need plenty of rest and vitamins.', 'Bạn cần nghỉ ngơi thật nhiều và bổ sung vitamin.', '/juː niːd ˈplɛn.ti ɒv rɛst ænd ˈvɪt.ə.mɪnz/'),
        _s('I hope you recover quickly and feel better soon.', 'Hy vọng bạn sẽ mau chóng bình phục và cảm thấy khỏe hơn.', '/aɪ həʊp juː rɪˈkʌv.ər ˈkwɪk.li ænd fiːl ˈbɛt.ər suːn/'),
        _s('Staying active keeps illness away.', 'Duy trì vận động giúp xua tan bệnh tật.', '/ˈsteɪ.ɪŋ ˈæk.tɪv kiːps ˈɪl.nəs əˈweɪ/'),
      ]),
      _createLesson('A2', 8, 'Công việc văn phòng căn bản', 'work', Icons.business_center_rounded, 'Gửi email, sắp xếp lịch hẹn và trao đổi đồng nghiệp.', [
        _s('I will send you the document via email shortly.', 'Tôi sẽ sớm gửi tài liệu cho bạn qua email.', '/aɪ wɪl sɛnd juː ðə ˈdɒk.jʊ.mənt ˈvaɪə ˈiː.meɪl ˈʃɔːt.li/'),
        _s('Can we reschedule our meeting to two o clock?', 'Chúng ta có thể dời cuộc họp sang hai giờ được không?', '/kæn wiː ˌriːˈskɛdʒ.uːl ˈaʊə ˈmiː.tɪŋ tuː tuː əˈklɒk/'),
        _s('Please review the report and give your feedback.', 'Làm ơn xem lại bản báo cáo và cho tôi ý kiến nhé.', '/pliːz rɪˈvjuː ðə rɪˈpɔːt ænd ɡɪv jɔː ˈfiːd.bæk/'),
        _s('Thank you for collaborating with our team.', 'Cảm ơn bạn đã hợp tác cùng đội ngũ chúng tôi.', '/θæŋk juː fɔː kəˈlæb.ə.reɪ.tɪŋ wɪð ˈaʊə tiːm/'),
        _s('We finished the assignment ahead of deadline.', 'Chúng tôi đã hoàn thành nhiệm vụ trước thời hạn.', '/wiː ˈfɪn.ɪʃt ðə əˈsaɪn.mənt əˈhɛd ɒv ˈdɛd.laɪn/'),
        _s('Good teamwork leads to great success.', 'Làm việc nhóm ăn ý sẽ dẫn tới thành công lớn.', '/ɡʊd ˈtiːm.wɜːk liːdz tuː ɡreɪt səkˈsɛs/'),
      ]),
      _createLesson('A2', 9, 'Công nghệ & Mạng xã hội', 'daily', Icons.smartphone_rounded, 'Thảo luận về ứng dụng, tin nhắn và thiết bị số.', [
        _s('My smartphone battery is running very low.', 'Pin điện thoại của tôi đang sắp cạn rồi.', '/maɪ ˈsmɑːt.fəʊn ˈbæt.ər.i ɪz ˈrʌn.ɪŋ ˈvɛr.i ləʊ/'),
        _s('Could I borrow your fast phone charger?', 'Tôi có thể mượn cục sạc nhanh điện thoại của bạn không?', '/kʊd aɪ ˈbɒr.əʊ jɔː fɑːst fəʊn ˈtʃɑː.dʒər/'),
        _s('I downloaded a great app for practicing English.', 'Tôi vừa tải một ứng dụng rất hay để luyện tiếng Anh.', '/aɪ ˌdaʊnˈləʊ.dɪd ə ɡreɪt æp fɔː ˈpræk.tɪs.ɪŋ ˈɪŋ.ɡlɪʃ/'),
        _s('Follow my channel for useful daily learning tips.', 'Hãy theo dõi kênh của tôi để nhận mẹo học hay mỗi ngày.', '/ˈfɒl.əʊ maɪ ˈtʃæn.əl fɔː ˈjuːs.fəl ˈdeɪ.li ˈlɜː.nɪŋ tɪps/'),
        _s('Technology makes global connection easier.', 'Công nghệ giúp kết nối toàn cầu trở nên dễ dàng hơn.', '/tɛkˈnɒl.ə.dʒi meɪks ˈɡləʊ.bəl kəˈnɛk.ʃən ˈiː.zi.ər/'),
        _s('Always protect your personal privacy online.', 'Luôn luôn bảo vệ quyền riêng tư cá nhân trên mạng.', '/ˈɔːl.weɪz prəˈtɛkt jɔː ˈpɜː.sən.əl ˈprɪv.ə.si ˈɒn.laɪn/'),
      ]),
      _createLesson('A2', 10, 'Tự tin đàm thoại cuộc sống', 'daily', Icons.psychology_rounded, 'Củng cố ngữ điệu và phát âm trôi chảy tự nhiên.', [
        _s('Consistency is the key to mastering English.', 'Sự kiên trì là chìa khóa để làm chủ tiếng Anh.', '/kənˈsɪs.tən.si ɪz ðə kiː tuː ˈmɑː.stər.ɪŋ ˈɪŋ.ɡlɪʃ/'),
        _s('I feel my accent improving noticeably each week.', 'Tôi cảm thấy ngữ điệu của mình cải thiện rõ rệt mỗi tuần.', '/aɪ fiːl maɪ ˈæk.sənt ɪmˈpruː.vɪŋ ˈnəʊ.tɪ.sə.bli iːtʃ wiːk/'),
        _s('Never hesitate to express your bright ideas.', 'Đừng bao giờ ngần ngại bày tỏ những ý tưởng sáng giá.', '/ˈnɛv.ər ˈhɛz.ɪ.teɪt tuː ɪkˈsprɛs jɔː braɪt aɪˈdɪəz/'),
        _s('Every small effort counts toward our dream.', 'Mỗi nỗ lực nhỏ đều góp phần tạo nên ước mơ của chúng ta.', '/ˈɛv.ri smɔːl ˈɛf.ət kaʊnts təˈwɔːdz ˈaʊə driːm/'),
        _s('I enjoy speaking English with foreign friends.', 'Tôi thích trò chuyện tiếng Anh với bạn bè quốc tế.', '/aɪ ɪnˈdʒɔɪ ˈspiːk.ɪŋ ˈɪŋ.ɡlɪʃ wɪð ˈfɒr.ən frɛndz/'),
        _s('Congratulations on finishing Level A2!', 'Chúc mừng bạn đã hoàn thành xuất sắc Level A2!', '/kənˌɡrætʃ.ʊˈleɪ.ʃənz ɒn ˈfɪn.ɪʃ.ɪŋ ˈlɛv.əl eɪ tuː/'),
      ]),
    ],
  );

  // ===========================================================================
  // LEVEL B1: INTERMEDIATE (TRUNG CẤP)
  // ===========================================================================
  static final CourseLevel _levelB1 = CourseLevel(
    code: 'B1',
    title: 'Level B1 - Intermediate',
    subtitle: 'Trung cấp & Giao tiếp tự nhiên',
    description: 'Thảo luận sâu về công việc, du lịch quốc tế, giải quyết tình huống và diễn đạt cảm xúc tinh tế.',
    primaryColor: const Color(0xFF1976D2), // Xanh dương đậm
    secondaryColor: const Color(0xFFE3F2FD),
    icon: Icons.trending_up_rounded,
    lessons: [
      _createLesson('B1', 1, 'Du lịch quốc tế & Sân bay', 'travel', Icons.flight_takeoff_rounded, 'Thủ tục hàng không, quá cảnh và giải quyết vấn đề.', [
        _s('Which terminal does the flight to London depart from?', 'Chuyến bay đi Luân Đôn khởi hành từ nhà ga nào?', '/wɪtʃ ˈtɜː.mɪ.nəl dʌz ðə flaɪt tuː ˈlʌn.dən dɪˈpɑːt frɒm/'),
        _s('I would like an aisle seat near the emergency exit.', 'Tôi muốn một ghế cạnh lối đi gần cửa thoát hiểm.', '/aɪ wʊd laɪk ən aɪl siːt nɪər ðə ɪˈmɜː.dʒən.si ˈɛɡ.zɪt/'),
        _s('My luggage appears to have been delayed or misplaced.', 'Hành lý của tôi dường như đã bị chậm trễ hoặc thất lạc.', '/maɪ ˈlʌɡ.ɪdʒ əˈpɪəz tuː hæv biːn dɪˈleɪd ɔː ˌmɪsˈpleɪst/'),
        _s('Could you assist me in filing a missing baggage report?', 'Bạn có thể hỗ trợ tôi khai báo báo cáo thất lạc hành lý không?', '/kʊd juː əˈsɪst miː ɪn ˈfaɪ.lɪŋ ə ˈmɪs.ɪŋ ˈbæɡ.ɪdʒ rɪˈpɔːt/'),
        _s('Traveling broadens our horizons and enriches our minds.', 'Du lịch mở rộng tầm nhìn và làm phong phú tâm hồn.', '/ˈtræv.əl.ɪŋ ˈbrɔː.dənz ˈaʊə həˈraɪ.zənz ænd ɪnˈrɪtʃ.ɪz ˈaʊə maɪndz/'),
        _s('Always keep your passport in a secure pocket.', 'Hãy luôn cất hộ chiếu trong ngăn an toàn.', '/ˈɔːl.weɪz kiːp jɔː ˈpɑːs.pɔːt ɪn ə sɪˈkjʊər ˈpɒk.ɪt/'),
      ]),
      _createLesson('B1', 2, 'Thuyết trình công việc', 'work', Icons.slideshow_rounded, 'Mở đầu, kết nối ý và kết luận bài thuyết trình.', [
        _s('Let me begin by introducing our quarterly objectives.', 'Cho phép tôi bắt đầu bằng việc giới thiệu các mục tiêu quý này.', '/lɛt miː bɪˈɡɪn baɪ ˌɪn.trəˈdjuː.sɪŋ ˈaʊə ˈkwɔː.təl.i əbˈdʒɛk.tɪvz/'),
        _s('As illustrated in the chart, our user growth rose by twenty percent.', 'Như minh họa trên biểu đồ, lượng người dùng tăng 20%.', '/æz ˈɪl.ə.streɪ.tɪd ɪn ðə tʃɑːt ˈaʊə ˈjuː.zər ɡrəʊθ rəʊz baɪ ˈtwɛn.ti pəˈsɛnt/'),
        _s('Now let us move on to the primary challenges we faced.', 'Bây giờ chúng ta hãy chuyển sang những thách thức chính đã đối mặt.', '/naʊ lɛt ʌs muːv ɒn tuː ðə ˈpraɪ.mər.i ˈtʃæl.ɪn.dʒɪz wiː feɪst/'),
        _s('To summarize, innovation is our fundamental competitive advantage.', 'Tóm lại, đổi mới sáng tạo là lợi thế cạnh tranh cốt lõi của chúng ta.', '/tuː ˈsʌm.ə.raɪz ˌɪn.əˈveɪ.ʃən ɪz ˈaʊə ˌfʌn.dəˈmɛn.təl kəmˈpɛt.ɪ.tɪv ədˈvɑːn.tɪdʒ/'),
        _s('I welcome any questions or suggestions you may have.', 'Tôi hoan nghênh mọi câu hỏi hoặc góp ý từ các bạn.', '/aɪ ˈwɛl.kəm ˈɛn.i ˈkwɛs.tʃənz ɔː səˈdʒɛs.tʃənz juː meɪ hæv/'),
        _s('Thank you all for your time and undivided attention.', 'Cảm ơn tất cả các bạn đã dành thời gian lắng nghe.', '/θæŋk juː ɔːl fɔː jɔː taɪm ænd ˌʌn.dɪˈvaɪ.dɪd əˈtɛn.ʃən/'),
      ]),
      _createLesson('B1', 3, 'Kế hoạch nghề nghiệp & Tương lai', 'work', Icons.work_outline_rounded, 'Bày tỏ tham vọng nghề nghiệp và định hướng cá nhân.', [
        _s('I am passionate about software engineering and cloud computing.', 'Tôi đam mê ngành kỹ thuật phần mềm và điện toán đám mây.', '/aɪ æm ˈpæʃ.ən.ət əˈbaʊt ˈsɒft.weər ˌɛn.dʒɪˈnɪə.rɪŋ ænd klaʊd kəmˈpjuː.tɪŋ/'),
        _s('I aim to obtain international certification within this year.', 'Tôi đặt mục tiêu lấy chứng chỉ quốc tế trong năm nay.', '/aɪ eɪm tuː əbˈteɪn ˌɪn.təˈnæʃ.ən.əl ˌsɜː.tɪ.fɪˈkeɪ.ʃən wɪðˈɪn ðɪs jɪər/'),
        _s('Continuous learning is vital for long-term career advancement.', 'Học hỏi không ngừng là điều sống còn để thăng tiến nghề nghiệp.', '/kənˈtɪn.ju.əs ˈlɜː.nɪŋ ɪz ˈvaɪ.təl fɔː lɒŋ tɜːm kəˈrɪər ədˈvɑːns.mənt/'),
        _s('I want to lead challenging and impactful technology projects.', 'Tôi muốn dẫn dắt những dự án công nghệ thử thách và giàu ảnh hưởng.', '/aɪ wɒnt tuː liːd ˈtʃæl.ɪn.dʒɪŋ ænd ɪmˈpækt.fəl tɛkˈnɒl.ə.dʒi ˈprɒdʒ.ɛkts/'),
        _s('Work-life harmony ensures sustainable creative energy.', 'Sự hài hòa công việc và cuộc sống đảm bảo năng lượng sáng tạo bền bỉ.', '/wɜːk laɪf ˈhɑː.mə.ni ɪnˈʃʊəz səˈsteɪ.nə.bəl kriˈeɪ.tɪv ˈɛn.ə.dʒi/'),
        _s('Hard work and perseverance always open new doors.', 'Chăm chỉ và sự kiên trì luôn mở ra những cánh cửa mới.', '/hɑːd wɜːk ænd ˌpɜː.sɪˈvɪə.rəns ˈɔːl.weɪz ˈəʊ.pən njuː dɔːz/'),
      ]),
      _createLesson('B1', 4, 'Bảo vệ môi trường xanh', 'daily', Icons.forest_rounded, 'Nêu quan điểm về biến đổi khí hậu và lối sống bền vững.', [
        _s('We must reduce plastic waste to protect our oceans.', 'Chúng ta phải cắt giảm rác thải nhựa để bảo vệ đại dương.', '/wiː mʌst rɪˈdjuːs ˈplæs.tɪk weɪst tuː prəˈtɛkt ˈaʊər ˈəʊ.ʃənz/'),
        _s('Using renewable energy contributes to fighting climate change.', 'Sử dụng năng lượng tái tạo góp phần chống biến đổi khí hậu.', '/ˈjuː.zɪŋ rɪˈnjuː.ə.bəl ˈɛn.ə.dʒi kənˈtrɪb.juːts tuː ˈfaɪ.tɪŋ ˈklaɪ.mət tʃeɪndʒ/'),
        _s('Planting trees creates fresh green spaces in urban areas.', 'Trồng cây xanh tạo không gian trong lành nơi đô thị.', '/ˈplɑːn.tɪŋ triːz kriˈeɪts frɛʃ ɡriːn ˈspeɪ.sɪz ɪn ˈɜː.bən ˈeə.ri.əz/'),
        _s('Small conscious daily habits make a substantial global difference.', 'Những thói quen nhỏ mỗi ngày tạo nên sự khác biệt to lớn trên toàn cầu.', '/smɔːl ˈkɒn.ʃəs ˈdeɪ.li ˈhæb.ɪts meɪk ə səbˈstæn.ʃəl ˈɡləʊ.bəl ˈdɪf.ərəns/'),
        _s('Every individual holds responsibility for the future planet.', 'Mỗi cá nhân đều có trách nhiệm với tương lai hành tinh này.', '/ˈɛv.ri ˌɪn.dɪˈvɪdʒ.u.əl həʊldz rɪˌspɒn.sɪˈbɪl.ə.ti fɔː ðə ˈfjuː.tʃər ˈplæn.ɪt/'),
        _s('Let us cherish and conserve the beauty of nature.', 'Hãy trân trọng và giữ gìn vẻ đẹp của mẹ thiên nhiên.', '/lɛt ʌs ˈtʃɛr.ɪʃ ænd kənˈsɜːv ðə ˈbjuː.ti ɒv ˈneɪ.tʃər/'),
      ]),
      _createLesson('B1', 5, 'Văn hóa & Lễ hội truyền thống', 'daily', Icons.celebration_rounded, 'Giới thiệu bản sắc văn hóa Việt Nam và thế giới.', [
        _s('Tet is the most sacred traditional festival in Vietnam.', 'Tết là ngày lễ truyền thống thiêng liêng nhất tại Việt Nam.', '/tɛt ɪz ðə məʊst ˈseɪ.krɪd trəˈdɪʃ.ən.əl ˈfɛs.tɪ.vəl ɪn ˌvjɛtˈnæm/'),
        _s('Families gather together to enjoy sticky rice cakes and tea.', 'Các gia đình quây quần bên nhau thưởng thức bánh chưng và trà.', '/ˈfæm.ɪ.liz ˈɡæð.ər təˈɡɛð.ər tuː ɪnˈdʒɔɪ ˈstɪk.i raɪs keɪks ænd tiː/'),
        _s('Cultural diversity enriches human empathy and mutual respect.', 'Sự đa dạng văn hóa làm phong phú sự thấu cảm và tôn trọng lẫn nhau.', '/ˈkʌl.tʃər.əl daɪˈvɜː.sɪ.ti ɪnˈrɪtʃ.ɪz ˈhjuː.mən ˈɛm.pə.θi ænd ˈmjuː.tʃu.əl rɪˈspɛkt/'),
        _s('Traditional costumes reflect centuries of historical heritage.', 'Trang phục truyền thống phản ánh hàng thế kỷ di sản lịch sử.', '/trəˈdɪʃ.ən.əl ˈkɒs.tjuːmz rɪˈflɛkt ˈsɛn.tʃʊ.riz ɒv hɪˈstɒr.ɪ.kəl ˈhɛr.ɪ.tɪdʒ/'),
        _s('I love learning about different folklore and customs.', 'Tôi rất thích tìm hiểu về phong tục và truyện dân gian của các nước.', '/aɪ lʌv ˈlɜː.nɪŋ əˈbaʊt ˈdɪf.ərənt ˈfəʊk.lɔːr ænd ˈkʌs.təmz/'),
        _s('Heritage is a bridge connecting our past with the future.', 'Di sản là cây cầu nối kết quá khứ với tương lai.', '/ˈhɛr.ɪ.tɪdʒ ɪz ə brɪdʒ kəˈnɛk.tɪŋ ˈaʊə pɑːst wɪð ðə ˈfjuː.tʃər/'),
      ]),
      _createLesson('B1', 6, 'Giải quyết vấn đề dịch vụ khách hàng', 'work', Icons.support_agent_rounded, 'Khiếu nại lịch sự và đàm phán giải pháp thỏa đáng.', [
        _s('I am calling regarding a discrepancy in my recent invoice.', 'Tôi gọi điện liên quan đến sự sai lệch trong hóa đơn gần đây.', '/aɪ æm ˈkɔː.lɪŋ rɪˈɡɑː.dɪŋ ə dɪˈskrɛp.ən.si ɪn maɪ ˈriː.sənt ˈɪn.vɔɪs/'),
        _s('The product received does not match the online description.', 'Sản phẩm nhận được không đúng với mô tả trên mạng.', '/ðə ˈprɒd.ʌkt rɪˈsiːvd dʌz nɒt mætʃ ðə ˈɒn.laɪn dɪˈskrɪp.ʃən/'),
        _s('Could you arrange a replacement or provide a prompt refund?', 'Bạn có thể sắp xếp đổi hàng hoặc hoàn tiền nhanh chóng không?', '/kʊd juː əˈreɪndʒ ə rɪˈpleɪs.mənt ɔː prəˈvaɪd ə prɒmpt ˈriː.fʌnd/'),
        _s('I appreciate your prompt handling and professional assistance.', 'Tôi đánh giá cao sự xử lý kịp thời và hỗ trợ chuyên nghiệp của bạn.', '/aɪ əˈpriː.ʃi.eɪt jɔː prɒmpt ˈhæn.dlɪŋ ænd prəˈfɛʃ.ən.əl əˈsɪs.təns/'),
        _s('Customer satisfaction is always our highest commitment.', 'Sự hài lòng của khách hàng luôn là cam kết cao nhất của chúng tôi.', '/ˈkʌs.tə.mər ˌsæt.ɪsˈfæk.ʃən ɪz ˈɔːl.weɪz ˈaʊə ˈhaɪ.ɪst kəˈmɪt.mənt/'),
        _s('Politeness and patience solve almost every difficult conflict.', 'Lịch sự và kiên nhẫn giải quyết được hầu hết các xung đột khó khăn.', '/pəˈlaɪt.nəs ænd ˈpeɪ.ʃəns sɒlv ˈɔːl.məʊst ˈɛv.ri ˈdɪf.ɪ.kəlt ˈkɒn.flɪkt/'),
      ]),
      _createLesson('B1', 7, 'Ý kiến cá nhân & Tranh biện', 'daily', Icons.forum_rounded, 'Đưa ra luận điểm, đồng tình và phản bác lịch sự.', [
        _s('From my perspective, remote working boosts overall productivity.', 'Theo góc nhìn của tôi, làm việc từ xa thúc đẩy năng suất tổng thể.', '/frɒm maɪ pəˈspɛk.tɪv rɪˈməʊt ˈwɜː.kɪŋ buːsts ˈəʊ.vər.ɔːl ˌprɒd.ʌkˈtɪv.ə.ti/'),
        _s('I understand your point, but we should consider financial risks.', 'Tôi hiểu ý bạn, nhưng chúng ta cần cân nhắc rủi ro tài chính.', '/aɪ ˌʌn.dəˈstænd jɔː pɔɪnt bʌt wiː ʃʊd kənˈsɪd.ər faɪˈnæn.ʃəl rɪsks/'),
        _s('I completely agree with the proposed strategic solution.', 'Tôi hoàn toàn đồng ý với giải pháp chiến lược đã được đề xuất.', '/aɪ kəmˈpliːt.li əˈɡriː wɪð ðə prəˈpəʊzd strəˈtiː.dʒɪk səˈluː.ʃən/'),
        _s('Let us examine both advantages and disadvantages carefully.', 'Chúng ta hãy xem xét kỹ lưỡng cả ưu điểm và nhược điểm.', '/lɛt ʌs ɪɡˈzæm.ɪn bəʊθ ədˈvɑːn.tɪ.dʒɪz ænd ˌdɪs.ədˈvɑːn.tɪ.dʒɪz ˈkeə.fəl.i/'),
        _s('Open dialogue fosters mutual trust and creative breakthroughs.', 'Đối thoại cởi mở nuôi dưỡng lòng tin và đột phá sáng tạo.', '/ˈəʊ.pən ˈdaɪ.ə.lɒɡ ˈfɒs.təz ˈmjuː.tʃu.əl trʌst ænd kriˈeɪ.tɪv ˈbreɪk.θruːz/'),
        _s('Constructive debate enriches any collaborative team.', 'Tranh biện mang tính xây dựng làm phong phú bất kỳ đội ngũ nào.', '/kənˈstrʌk.tɪv dɪˈbeɪt ɪnˈrɪtʃ.ɪz ˈɛn.i kəˈlæb.ər.ə.tɪv tiːm/'),
      ]),
      _createLesson('B1', 8, 'Tài chính cá nhân & Đầu tư', 'work', Icons.savings_rounded, 'Lập ngân sách, tiết kiệm và quản lý chi tiêu thông minh.', [
        _s('Creating a monthly budget helps track unnecessary expenses.', 'Lập ngân sách hàng tháng giúp theo dõi các khoản chi không cần thiết.', '/kriˈeɪ.tɪŋ ə ˈmʌnθ.li ˈbʌdʒ.ɪt hɛlps træk ʌnˈnɛs.ə.sər.i ɪkˈspɛn.sɪz/'),
        _s('Building an emergency fund provides invaluable peace of mind.', 'Xây dựng quỹ khẩn cấp mang lại sự an tâm vô giá.', '/ˈbɪl.dɪŋ ən ɪˈmɜː.dʒən.si fʌnd prəˈvaɪdz ɪnˈvæl.jʊ.ə.bəl piːs ɒv maɪnd/'),
        _s('Wise investing requires thorough market research and discipline.', 'Đầu tư thông minh đòi hỏi kỷ luật và nghiên cứu thị trường kỹ càng.', '/waɪz ɪnˈvɛst.ɪŋ rɪˈkwaɪəz ˈθʌr.ə ˈmɑː.kɪt rɪˈsɜːtʃ ænd ˈdɪs.ə.plɪn/'),
        _s('Avoid impulsive buying by waiting twenty-four hours.', 'Tránh mua sắm bốc đồng bằng cách chờ đợi hai mươi tư giờ.', '/əˈvɔɪd ɪmˈpʌl.sɪv ˈbaɪ.ɪŋ baɪ ˈweɪ.tɪŋ ˈtwɛn.ti fɔːr ˈaʊəz/'),
        _s('Financial freedom allows us to pursue our true passions.', 'Tự do tài chính cho phép chúng ta theo đuổi đam mê đích thực.', '/faɪˈnæn.ʃəl ˈfriː.dəm əˈlaʊz ʌs tuː pəˈsjuː ˈaʊə truː ˈpæʃ.ənz/'),
        _s('Invest in your own knowledge and personal growth first.', 'Hãy đầu tư vào kiến thức và sự phát triển bản thân trước hết.', '/ɪnˈvɛst ɪn jɔːr əʊn ˈnɒl.ɪdʒ ænd ˈpɜː.sən.əl ɡrəʊθ fɜːst/'),
      ]),
      _createLesson('B1', 9, 'Nghệ thuật & Đời sống tinh thần', 'daily', Icons.brush_rounded, 'Cảm nhận về hội họa, sách, âm nhạc và triết lý sống.', [
        _s('Reading classic literature expands our emotional vocabulary.', 'Đọc văn học kinh điển mở rộng vốn từ vựng cảm xúc của chúng ta.', '/ˈriː.dɪŋ ˈklæs.ɪk ˈlɪt.rə.tʃər ɪkˈspændz ˈaʊər ɪˈməʊ.ʃən.əl vəʊˈkæb.jʊ.lər.i/'),
        _s('The subtle colors in this painting evoke deep tranquility.', 'Gam màu tinh tế trong bức tranh gợi lên sự tĩnh lặng sâu sắc.', '/ðə ˈsʌt.əl ˈkʌl.əz ɪn ðɪs ˈpeɪn.tɪŋ ɪˈvəʊk diːp træŋˈkwɪl.ə.ti/'),
        _s('Music communicates feelings that words cannot express.', 'Âm nhạc truyền tải những xúc cảm mà ngôn từ không thể diễn tả.', '/ˈmjuː.zɪk kəˈmjuː.nɪ.keɪts ˈfiː.lɪŋz ðæt wɜːdz ˈkæn.ɒt ɪkˈsprɛs/'),
        _s('Mindfulness meditation cultivates inner calm in busy lives.', 'Thiền chánh niệm nuôi dưỡng sự tĩnh lặng nội tâm trong đời sống bận rộn.', '/ˈmaɪnd.fəl.nəs ˌmɛd.ɪˈteɪ.ʃən ˈkʌl.tɪ.veɪts ˈɪn.ər kɑːm ɪn ˈbɪz.i laɪvz/'),
        _s('Art reminds us to slow down and appreciate the present.', 'Nghệ thuật nhắc nhở ta sống chậm lại và trân quý hiện tại.', '/ɑːt rɪˈmaɪndz ʌs tuː sləʊ daʊn ænd əˈpriː.ʃi.eɪt ðə ˈprɛz.ənt/'),
        _s('Creativity blossoms when we dare to be authentically curious.', 'Sự sáng tạo nở hoa khi ta dám tò mò và chân thật với bản thân.', '/ˌkriː.eɪˈtɪv.ə.ti ˈblɒs.əmz wɛn wiː deər tuː biː ɔːˈθɛn.tɪ.kəl.i ˈkjʊə.ri.əs/'),
      ]),
      _createLesson('B1', 10, 'Làm chủ phát âm nâng cao B1', 'daily', Icons.military_tech_rounded, 'Chinh phục trọng âm câu, nối âm mượt mà và nhịp điệu bản xứ.', [
        _s('Fluency comes from daily consistent practice and immersion.', 'Sự lưu loát đến từ việc luyện tập kiên trì và đắm mình mỗi ngày.', '/ˈfluː.ən.si kʌmz frɒm ˈdeɪ.li kənˈsɪs.tənt ˈpræk.tɪs ænd ɪˈmɜː.ʃən/'),
        _s('Connected speech makes your English sound remarkably natural.', 'Kỹ thuật nối âm giúp tiếng Anh của bạn nghe tự nhiên lạ thường.', '/kəˈnɛk.tɪd spiːtʃ meɪks jɔːr ˈɪŋ.ɡlɪʃ saʊnd rɪˈmɑː.kə.bli ˈnætʃ.ər.əl/'),
        _s('Never fear making mistakes, they are milestones of progress.', 'Đừng bao giờ sợ mắc lỗi, chúng là những cột mốc của sự tiến bộ.', '/ˈnɛv.ər fɪər ˈmeɪ.kɪŋ mɪsˈteɪks ðeɪ ɑː ˈmaɪl.stəʊnz ɒv ˈprəʊ.ɡrɛs/'),
        _s('You have successfully built an impressive intermediate foundation.', 'Bạn đã xây dựng thành công nền tảng trung cấp đáng tự hào.', '/juː hæv səkˈsɛs.fəl.i bɪlt ən ɪmˈprɛs.ɪv ˌɪn.təˈmiː.di.ət faʊnˈdeɪ.ʃən/'),
        _s('Onward with great passion to Level B2!', 'Tiến lên Level B2 với niềm đam mê bất tận!', '/ˈɒn.wəd wɪð ɡreɪt ˈpæʃ.ən tuː ˈlɛv.əl biː tuː/'),
        _s('Celebrate your milestone, you are speaking English beautifully!', 'Hãy ăn mừng cột mốc này, bạn đang nói tiếng Anh rất tuyệt vời!', '/ˈsɛl.ə.breɪt jɔː ˈmaɪl.stəʊn juː ɑː ˈspiːk.ɪŋ ˈɪŋ.ɡlɪʃ ˈbjuː.tɪ.fəl.i/'),
      ]),
    ],
  );

  // ===========================================================================
  // LEVEL B2: UPPER-INTERMEDIATE (TRUNG CAO CẤP)
  // ===========================================================================
  static final CourseLevel _levelB2 = CourseLevel(
    code: 'B2',
    title: 'Level B2 - Upper-Intermediate',
    subtitle: 'Chuyên nghiệp & Lưu loát',
    description: 'Thuyết phục, đàm phán thương mại, phỏng vấn xin việc quốc tế và xử lý các vấn đề chuyên sâu.',
    primaryColor: const Color(0xFF7B1FA2), // Tím chuyên nghiệp
    secondaryColor: const Color(0xFFF3E5F5),
    icon: Icons.psychology_alt_rounded,
    lessons: [
      _createLesson('B2', 1, 'Phỏng vấn xin việc quốc tế', 'work', Icons.badge_rounded, 'Trả lời xuất sắc câu hỏi điểm mạnh, điểm yếu và thành tích.', [
        _s('Could you elaborate on a complex project you spearheaded?', 'Bạn có thể chia sẻ sâu về một dự án phức tạp bạn từng dẫn dắt?', '/kʊd juː ɪˈlæb.ə.reɪt ɒn ə ˈkɒm.plɛks ˈprɒdʒ.ɛkt juː ˈspɪə.hɛd.ɪd/'),
        _s('I thrive under demanding deadlines by prioritizing strategic milestones.', 'Tôi làm việc tốt dưới áp lực thời gian nhờ ưu tiên các mốc chiến lược.', '/aɪ θraɪv ˈʌn.dər dɪˈmɑːn.dɪŋ ˈdɛd.laɪnz baɪ praɪˈɒr.ɪ.taɪ.zɪŋ strəˈtiː.dʒɪk ˈmaɪl.stəʊnz/'),
        _s('My greatest strength lies in bridging technical teams and business stakeholders.', 'Thế mạnh lớn nhất của tôi là kết nối giữa đội kỹ thuật và các bên kinh doanh.', '/maɪ ˈɡreɪ.tɪst strɛŋθ laɪz ɪn ˈbrɪdʒ.ɪŋ ˈtɛk.nɪ.kəl tiːmz ænd ˈbɪz.nɪs ˈsteɪkˌhəʊl.dəz/'),
        _s('I actively seek constructive criticism to elevate our delivery quality.', 'Tôi chủ động đón nhận phản hồi xây dựng để nâng tầm chất lượng sản phẩm.', '/aɪ ˈæk.tɪv.li siːk kənˈstrʌk.tɪv ˈkrɪt.ɪ.sɪ.zəm tuː ˈɛl.ɪ.veɪt ˈaʊə dɪˈlɪv.ər.i ˈkwɒl.ə.ti/'),
        _s('Why do you consider yourself the best fit for our corporate culture?', 'Tại sao bạn coi mình là người phù hợp nhất với văn hóa công ty chúng tôi?', '/waɪ duː juː kənˈsɪd.ər jɔːˈsɛlf ðə bɛst fɪt fɔːr ˈaʊə ˈkɔː.pər.ət ˈkʌl.tʃər/'),
        _s('I am committed to creating tangible value from day one.', 'Tôi cam kết sẽ tạo ra giá trị thiết thực ngay từ ngày đầu tiên.', '/aɪ æm kəˈmɪt.ɪd tuː kriˈeɪ.tɪŋ ˈtæn.dʒə.bəl ˈvæl.juː frɒm deɪ wʌn/'),
      ]),
      _createLesson('B2', 2, 'Kỹ năng Đàm phán thương mại', 'work', Icons.handshake_rounded, 'Thương lượng hợp đồng, giá cả và thỏa hiệp đôi bên cùng có lợi.', [
        _s('We propose a mutually beneficial partnership with flexible terms.', 'Chúng tôi đề xuất một quan hệ hợp tác đôi bên cùng có lợi với điều khoản linh hoạt.', '/wiː prəˈpəʊz ə ˈmjuː.tʃu.əl.i ˌbɛn.ɪˈfɪʃ.əl ˈpɑːt.nə.ʃɪp wɪð ˈflɛk.sə.bəl tɜːmz/'),
        _s('Could we explore potential room for compromise on the warranty clause?', 'Chúng ta có thể tìm kiếm điểm thỏa hiệp ở điều khoản bảo hành không?', '/kʊd wiː ɪkˈsplɔː pəˈtɛn.ʃəl ruːm fɔː ˈkɒm.prə.maɪz ɒn ðə ˈwɒr.ən.ti klɔːz/'),
        _s('Maintaining sustainable margins is paramount for our continued support.', 'Duy trì biên lợi nhuận bền vững là tối quan trọng để chúng tôi hỗ trợ lâu dài.', '/meɪnˈteɪ.nɪŋ səˈsteɪ.nə.bəl ˈmɑː.dʒɪnz ɪz ˈpær.ə.maʊnt fɔːr ˈaʊə kənˈtɪn.juːd səˈpɔːt/'),
        _s('Let us formalize these agreed points in a memorandum of understanding.', 'Chúng ta hãy chuẩn hóa những điểm đã thống nhất vào biên bản ghi nhớ.', '/lɛt ʌs ˈfɔː.mə.laɪz ðiːz əˈɡriːd pɔɪnts ɪn ə ˌmɛm.əˈræn.dəm ɒv ˌʌn.dəˈstæn.dɪŋ/'),
        _s('Transparency is the bedrock of enduring commercial alliances.', 'Minh bạch là nền tảng vững chắc của các liên minh thương mại bền vững.', '/trænsˈpær.ən.si ɪz ðə ˈbɛd.rɒk ɒv ɪnˈdjʊə.rɪŋ kəˈmɜː.ʃəl əˈlaɪ.əns.ɪz/'),
        _s('We eagerly look forward to fruitful long-term collaboration.', 'Chúng tôi vô cùng trông đợi sự hợp tác lâu dài và đơm hoa kết trái.', '/wiː ˈiː.ɡər.li lʊk ˈfɔː.wəd tuː ˈfruːt.fəl lɒŋ tɜːm kəˌlæb.əˈreɪ.ʃən/'),
      ]),
      _createLesson('B2', 3, 'Trí tuệ nhân tạo & Kỷ nguyên số', 'work', Icons.memory_rounded, 'Bàn luận về AI, tự động hóa và tương lai công nghệ.', [
        _s('Artificial intelligence is transforming industries at an unprecedented pace.', 'Trí tuệ nhân tạo đang làm thay đổi các ngành nghề với tốc độ chưa từng có.', '/ˌɑː.tɪˈfɪʃ.əl ɪnˈtɛl.ɪ.dʒəns ɪz trænsˈfɔː.mɪŋ ˈɪn.dəs.triz æt ən ʌnˈprɛs.ɪ.dɛn.tɪd peɪs/'),
        _s('Ethical frameworks must guide autonomous algorithmic decisions.', 'Khuôn khổ đạo đức phải dẫn dắt các quyết định thuật toán tự động.', '/ˈɛθ.ɪ.kəl ˈfreɪm.wɜːks mʌst ɡaɪd ɔːˈtɒn.ə.məs ˌæl.ɡəˈrɪð.mɪk dɪˈsɪʒ.ənz/'),
        _s('Human empathy and critical thinking remain irreplaceable.', 'Sự thấu cảm của con người và tư duy phản biện vẫn là điều không thể thay thế.', '/ˈhjuː.mən ˈɛm.pə.θi ænd ˈkrɪt.ɪ.kəl ˈθɪŋ.kɪŋ rɪˈmeɪn ˌɪr.ɪˈpleɪ.sə.bəl/'),
        _s('Data privacy demands rigorous security compliance and governance.', 'Quyền riêng tư dữ liệu đòi hỏi sự tuân thủ an ninh và quản trị nghiêm ngặt.', '/ˈdeɪ.tə ˈprɪv.ə.si dɪˈmɑːndz ˈrɪɡ.ər.əs sɪˈkjʊər.ə.ti kəmˈplaɪ.əns ænd ˈɡʌv.ən.əns/'),
        _s('Adaptive learning platforms personalize student outcomes remarkably.', 'Nền tảng học thích ứng cá nhân hóa kết quả của học viên một cách rõ rệt.', '/əˈdæp.tɪv ˈlɜː.nɪŋ ˈplæt.fɔːmz ˈpɜː.sən.əl.aɪz ˈstjuː.dənt ˈaʊtˌkʌmz rɪˈmɑː.kə.bli/'),
        _s('Embrace innovative tools to unlock unprecedented potential.', 'Hãy nắm bắt những công cụ đổi mới để khai phóng tiềm năng chưa từng có.', '/ɪmˈbreɪs ˈɪn.ə.veɪ.tɪv tuːlz tuː ʌnˈlɒk ʌnˈprɛs.ɪ.dɛn.tɪd pəˈtɛn.ʃəl/'),
      ]),
      _createLesson('B2', 4, 'Toàn cầu hóa & Đa văn hóa', 'daily', Icons.public_rounded, 'Hiểu sâu về hội nhập văn hóa và tư duy công dân toàn cầu.', [
        _s('Cross-cultural competence is essential in multinational enterprises.', 'Năng lực thấu hiểu đa văn hóa là điều cốt yếu trong doanh nghiệp đa quốc gia.', '/krɒs ˈkʌl.tʃər.əl ˈkɒm.pɪ.təns ɪz ɪˈsɛn.ʃəl ɪn ˌmʌl.tiˈnæʃ.ən.əl ˈɛn.tə.praɪ.zɪz/'),
        _s('Respecting diverse viewpoints inspires revolutionary innovations.', 'Tôn trọng các góc nhìn đa dạng truyền cảm hứng cho những đổi mới cách mạng.', '/rɪˈspɛk.tɪŋ daɪˈvɜːs ˈvjuːˌpɔɪnts ɪnˈspaɪəz ˌrɛv.əˈluː.ʃən.ər.i ˌɪn.əˈveɪ.ʃənz/'),
        _s('Stereotypes vanish when genuine human dialogue begins.', 'Định kiến sẽ tan biến khi đối thoại chân thành giữa con người bắt đầu.', '/ˈstɛr.i.ə.taɪps ˈvæn.ɪʃ wɛn ˈdʒɛn.ju.ɪn ˈhjuː.mən ˈdaɪ.ə.lɒɡ bɪˈɡɪnz/'),
        _s('Global citizenship entails empathy beyond geographical boundaries.', 'Tư cách công dân toàn cầu gắn liền với sự thấu cảm vượt qua mọi ranh giới địa lý.', '/ˈɡləʊ.bəl ˈsɪt.ɪ.zən.ʃɪp ɪnˈteɪlz ˈɛm.pə.θi bɪˈjɒnd ˌdʒiː.əˈɡræf.ɪ.kəl ˈbaʊn.dər.iz/'),
        _s('Language serves as the most intimate gateway to human culture.', 'Ngôn ngữ đóng vai trò là cánh cổng thân thuộc nhất dẫn vào văn hóa nhân loại.', '/ˈlæŋ.ɡwɪdʒ sɜːvz æz ðə məʊst ˈɪn.tɪ.mət ˈɡeɪt.weɪ tuː ˈhjuː.mən ˈkʌl.tʃər/'),
        _s('Unity in diversity strengthens global resilience.', 'Sự thống nhất trong đa dạng củng cố sức mạnh bền bỉ toàn cầu.', '/ˈjuː.nə.ti ɪn daɪˈvɜː.sɪ.ti ˈstrɛŋ.θənz ˈɡləʊ.bəl rɪˈzɪl.i.əns/'),
      ]),
      _createLesson('B2', 5, 'Lãnh đạo & Truyền cảm hứng', 'work', Icons.military_tech_rounded, 'Nghệ thuật dẫn dắt đội ngũ và thúc đẩy hiệu suất.', [
        _s('Authentic leaders empower others to surpass their own expectations.', 'Nhà lãnh đạo đích thực trao quyền để người khác vượt qua kỳ vọng của chính họ.', '/ɔːˈθɛn.tɪk ˈliː.dəz ɪmˈpaʊ.ər ˈʌð.əz tuː sɜːˈpɑːs ðeər əʊn ˌɛk.spɛkˈteɪ.ʃənz/'),
        _s('Clear communication aligns team energy toward shared milestones.', 'Giao tiếp rõ ràng giúp định hướng năng lượng đội ngũ tới những mục tiêu chung.', '/klɪər kəˌmjuː.nɪˈkeɪ.ʃən əˈlaɪnz tiːm ˈɛn.ə.dʒi təˈwɔːd ʃeəd ˈmaɪl.stəʊnz/'),
        _s('Vulnerability and honesty cultivate psychological safety in teams.', 'Sự chân thành và cởi mở tạo ra cảm giác an toàn tâm lý trong đội ngũ.', '/ˌvʌl.nər.əˈbɪl.ə.ti ænd ˈɒn.ɪ.sti ˈkʌl.tɪ.veɪt ˌsaɪ.kəˈlɒdʒ.ɪ.kəl ˈseɪf.ti ɪn tiːmz/'),
        _s('Recognizing individual contributions boosts organizational morale.', 'Ghi nhận đóng góp của từng cá nhân nâng cao tinh thần của toàn tổ chức.', '/ˈrɛk.əɡ.naɪ.zɪŋ ˌɪn.dɪˈvɪdʒ.u.əl ˌkɒn.trɪˈbjuː.ʃənz buːsts ˌɔː.ɡən.aɪˈzeɪ.ʃən.əl məˈrɑːl/'),
        _s('Great leaders create leaders, not merely followers.', 'Những nhà lãnh đạo vĩ đại tạo ra thêm nhiều nhà lãnh đạo, chứ không đơn thuần là người đi theo.', '/ɡreɪt ˈliː.dəz kriˈeɪt ˈliː.dəz nɒt ˈmɪə.li ˈfɒl.əʊ.əz/'),
        _s('Inspire through actions that reflect your deepest values.', 'Hãy truyền cảm hứng bằng những hành động phản ánh giá trị sâu sắc nhất của bạn.', '/ɪnˈspaɪə θruː ˈæk.ʃənz ðæt rɪˈflɛkt jɔː ˈdiː.pɪst ˈvæl.juːz/'),
      ]),
      _createLesson('B2', 6, 'Quản lý khủng hoảng & Rủi ro', 'work', Icons.warning_amber_rounded, 'Ứng phó sự cố và bảo vệ uy tín thương hiệu.', [
        _s('Swift and factual communication prevents speculative panic.', 'Giao tiếp nhanh chóng và dựa trên sự thật giúp ngăn ngừa sự hoang mang đồn đoán.', '/swɪft ænd ˈfæk.tʃu.əl kəˌmjuː.nɪˈkeɪ.ʃən prɪˈvɛnts ˈspɛk.jʊ.lə.tɪv ˈpæn.ɪk/'),
        _s('We implemented robust contingency plans to mitigate operational disruption.', 'Chúng tôi đã kích hoạt kế hoạch dự phòng vững chắc để giảm thiểu gián đoạn vận hành.', '/wiː ˈɪm.plɪ.mɛn.tɪd rəʊˈbʌst kənˈtɪn.dʒən.si plænz tuː ˈmɪt.ɪ.ɡeɪt ˌɒp.ərˈeɪ.ʃən.əl dɪsˈrʌp.ʃən/'),
        _s('Accountability during a crisis earns lasting stakeholder confidence.', 'Tinh thần chịu trách nhiệm trong khủng hoảng mang lại niềm tin bền vững từ các bên.', '/əˌkaʊn.təˈbɪl.ə.ti ˈdjʊə.rɪŋ ə ˈkraɪ.sɪs ɜːnz ˈlɑː.stɪŋ ˈsteɪkˌhəʊl.dər ˈkɒn.fɪ.dəns/'),
        _s('Conduct thorough post-incident analysis to eliminate systemic flaws.', 'Tiến hành phân tích kỹ sau sự cố để loại bỏ triệt để các lỗ hổng hệ thống.', '/kənˈdʌkt ˈθʌr.ə pəʊst ˈɪn.sɪ.dənt əˈnæl.ə.sɪs tuː ɪˈlɪm.ɪ.neɪt sɪˈstɛm.ɪk flɔːz/'),
        _s('Resilience is forged when organizations overcome severe adversity.', 'Bản lĩnh kiên cường được tôi luyện khi tổ chức vượt qua nghịch cảnh gay gắt.', '/rɪˈzɪl.i.əns ɪz fɔːdʒd wɛn ˌɔː.ɡən.aɪˈzeɪ.ʃənz ˌəʊ.vəˈkʌm sɪˈvɪər ədˈvɜː.sə.ti/'),
        _s('Preparedness turns vulnerability into strategic advantage.', 'Sự chuẩn bị kỹ càng biến điểm yếu thành lợi thế mang tính chiến lược.', '/prɪˈpeə.rɪd.nəs tɜːnz ˌvʌl.nər.əˈbɪl.ə.ti ˈɪn.tuː strəˈtiː.dʒɪk ədˈvɑːn.tɪdʒ/'),
      ]),
      _createLesson('B2', 7, 'Tâm lý học hành vi & Thấu cảm', 'daily', Icons.favorite_border_rounded, 'Hiểu động lực và giao tiếp thấu hiểu lòng người.', [
        _s('Active listening requires setting aside preconceived judgments.', 'Lắng nghe chủ động đòi hỏi việc gạt bỏ những định kiến có sẵn.', '/ˈæk.tɪv ˈlɪs.ən.ɪŋ rɪˈkwaɪəz ˈsɛt.ɪŋ əˈsaɪd ˌpriː.kənˈsiːvd ˈdʒʌdʒ.mənts/'),
        _s('Emotional intelligence often outweighs cognitive IQ in relationship building.', 'Trí tuệ cảm xúc thường quan trọng hơn chỉ số IQ trong việc xây dựng mối quan hệ.', '/ɪˈməʊ.ʃən.əl ɪnˈtɛl.ɪ.dʒəns ˈɒf.tən aʊtˈweɪz ˈkɒɡ.nɪ.tɪv aɪ kjuː ɪn rɪˈleɪ.ʃən.ʃɪp ˈbɪl.dɪŋ/'),
        _s('Non-verbal cues convey sincerity louder than spoken words.', 'Tín hiệu phi ngôn ngữ truyền tải sự chân thành mạnh mẽ hơn lời nói.', '/nɒn ˈvɜː.bəl kjuːz kənˈveɪ sɪnˈsɛr.ə.ti ˈlaʊ.dər ðæn ˈspəʊ.kən wɜːdz/'),
        _s('Empathy enables genuine understanding across generational divides.', 'Sự thấu cảm tạo ra sự thấu hiểu chân thành vượt qua khoảng cách thế hệ.', '/ˈɛm.pə.θi ɪˈneɪ.bəlz ˈdʒɛn.ju.ɪn ˌʌn.dəˈstæn.dɪŋ əˈkrɒs ˌdʒɛn.əˈreɪ.ʃən.əl dɪˈvaɪdz/'),
        _s('Cultivate compassionate curiosity rather than reactive judgment.', 'Hãy nuôi dưỡng sự tò mò đầy trắc ẩn thay vì vội vàng phán xét phản xạ.', '/ˈkʌl.tɪ.veɪt kəmˈpæʃ.ən.ət ˌkjʊə.riˈɒs.ə.ti ˈrɑː.ðər ðæn riˈæk.tɪv ˈdʒʌdʒ.mənt/'),
        _s('Understanding human motives empowers constructive collaboration.', 'Thấu hiểu động cơ con người giúp sự hợp tác trở nên xây dựng và hiệu quả.', '/ˌʌn.dəˈstæn.dɪŋ ˈhjuː.mən ˈməʊ.tɪvz ɪmˈpaʊ.əz kənˈstrʌk.tɪv kəˌlæb.əˈreɪ.ʃən/'),
      ]),
      _createLesson('B2', 8, 'Kinh tế vĩ mô & Chuỗi cung ứng', 'work', Icons.currency_exchange_rounded, 'Nắm bắt các xu thế thương mại và thị trường tài chính.', [
        _s('Inflationary pressures influenced interest rate adjustments worldwide.', 'Áp lực lạm phát đã tác động đến việc điều chỉnh lãi suất trên toàn cầu.', '/ɪnˈfleɪ.ʃən.ər.i ˈprɛʃ.əz ˈɪn.flʊ.ənst ˈɪn.trəst reɪt əˈdʒʌst.mənts ˈwɜːld.waɪd/'),
        _s('Supply chain diversification protects companies from geopolitical disruptions.', 'Đa dạng hóa chuỗi cung ứng bảo vệ doanh nghiệp trước các gián đoạn địa chính trị.', '/səˈplaɪ tʃeɪn daɪˌvɜː.sɪ.fɪˈkeɪ.ʃən prəˈtɛkts ˈkʌm.pə.niz frɒm ˌdʒiː.əʊ.pəˈlɪt.ɪ.kəl dɪsˈrʌp.ʃənz/'),
        _s('Sustainable consumer goods reflect evolving market preferences.', 'Hàng tiêu dùng bền vững phản ánh thị hiếu đang biến chuyển của thị trường.', '/səˈsteɪ.nə.bəl kənˈsjuː.mər ɡʊdz rɪˈflɛkt ɪˈvɒl.vɪŋ ˈmɑː.kɪt ˈprɛf.ər.əns.ɪz/'),
        _s('Strategic reserves guarantee liquidity during volatile economic quarters.', 'Dự trữ chiến lược đảm bảo tính thanh khoản trong các quý kinh tế biến động.', '/strəˈtiː.dʒɪk rɪˈzɜːvz ˌɡær.ənˈtiː lɪˈkwɪd.ə.ti ˈdjʊə.rɪŋ ˈvɒl.ə.taɪl ˌiː.kəˈnɒm.ɪk ˈkwɔː.təz/'),
        _s('Sound fiscal policies stimulate sustainable long-term enterprise growth.', 'Chính sách tài khóa lành mạnh kích thích tăng trưởng doanh nghiệp bền vững.', '/saʊnd ˈfɪs.kəl ˈpɒl.ə.siz ˈstɪm.jʊ.leɪt səˈsteɪ.nə.bəl lɒŋ tɜːm ˈɛn.tə.praɪz ɡrəʊθ/'),
        _s('Agile organizations quickly pivot amidst shifting macroeconomic cycles.', 'Tổ chức linh hoạt nhanh chóng chuyển mình thích ứng giữa các chu kỳ kinh tế.', '/ˈædʒ.aɪl ˌɔː.ɡən.aɪˈzeɪ.ʃənz ˈkwɪk.li ˈpɪv.ət əˈmɪdst ˈʃɪf.tɪŋ ˌmæk.rəʊˌiː.kəˈnɒm.ɪk ˈsaɪ.kəlz/'),
      ]),
      _createLesson('B2', 9, 'Tư duy Đổi mới & Khởi nghiệp', 'work', Icons.lightbulb_rounded, 'Biến ý tưởng thành hiện thực và xây dựng sản phẩm đột phá.', [
        _s('Disruptive ideas originate from questioning established legacy norms.', 'Ý tưởng đột phá bắt nguồn từ việc đặt câu hỏi trước những chuẩn mực cũ kỹ.', '/dɪsˈrʌp.tɪv aɪˈdɪəz əˈrɪdʒ.ɪ.neɪt frɒm ˈkwɛs.tʃən.ɪŋ ɪˈstæb.lɪʃt ˈlɛɡ.ə.si nɔːmz/'),
        _s('Failing fast allows startups to iterate rapidly toward product-market fit.', 'Thất bại nhanh cho phép startup lặp lại liên tục để tìm ra sản phẩm phù hợp thị trường.', '/ˈfeɪ.lɪŋ fɑːst əˈlaʊz ˈstɑːt.ʌps tuː ˈɪt.ər.eɪt ˈræp.ɪd.li təˈwɔːdz ˈprɒd.ʌkt ˈmɑː.kɪt fɪt/'),
        _s('Customer feedback loops should dictate product roadmap priorities.', 'Vòng phản hồi của khách hàng nên định hình thứ tự ưu tiên của lộ trình sản phẩm.', '/ˈkʌs.tə.mər ˈfiːd.bæk luːps ʃʊd dɪkˈteɪt ˈprɒd.ʌkt ˈrəʊd.mæp praɪˈɒr.ɪ.tiz/'),
        _s('Scalability requires robust cloud architecture and meticulous execution.', 'Khả năng mở rộng quy mô đòi hỏi kiến trúc đám mây vững vàng và thực thi tỉ mỉ.', '/ˌskeɪ.ləˈbɪl.ə.ti rɪˈkwaɪəz rəʊˈbʌst klaʊd ˈɑː.kɪ.tɛk.tʃər ænd məˈtɪk.jʊ.ləs ˌɛk.sɪˈkjuː.ʃən/'),
        _s('Passion fuels the persistence necessary to navigate entrepreneurial uncertainty.', 'Đam mê thắp lửa cho sự kiên trì vượt qua những bất định của khởi nghiệp.', '/ˈpæʃ.ən fjuːəlz ðə pəˈsɪs.təns ˈnɛs.ə.sər.i tuː ˈnæv.ɪ.ɡeɪt ˌɒn.trə.prəˈnɜː.ri.əl ʌnˈsɜː.tən.ti/'),
        _s('Dare to innovate, create solutions that genuinely transform lives.', 'Hãy dám đổi mới, tạo ra những giải pháp thực sự chuyển hóa đời sống con người.', '/deər tuː ˈɪn.ə.veɪt kriˈeɪt səˈluː.ʃənz ðæt ˈdʒɛn.ju.ɪn.li trænsˈfɔːm laɪvz/'),
      ]),
      _createLesson('B2', 10, 'Đỉnh cao Ngữ điệu B2', 'daily', Icons.star_rounded, 'Nhấn âm ngữ nghĩa, intonation chuẩn xác như phát thanh viên.', [
        _s('Mastering intonation conveys subtle nuance and intellectual sophistication.', 'Làm chủ ngữ điệu truyền tải được sắc thái tinh tế và chiều sâu trí tuệ.', '/ˈmɑː.stər.ɪŋ ˌɪn.təˈneɪ.ʃən kənˈveɪz ˈsʌt.əl ˈnjuː.ɑːns ænd ˌɪn.təlˈɛk.tʃu.əl səˌfɪs.tɪˈkeɪ.ʃən/'),
        _s('Speak with rhythm, pauses, and purposeful emphasis on pivotal words.', 'Hãy nói với nhịp điệu, khoảng ngắt và sự nhấn nhá có chủ đích vào từ then chốt.', '/spiːk wɪð ˈrɪð.əm ˈpɔː.zɪz ænd ˈpɜː.pəs.fəl ˈɛm.fə.sɪs ɒn ˈpɪv.ə.təl wɜːdz/'),
        _s('Your voice carries undeniable presence and compelling credibility.', 'Giọng nói của bạn toát lên phong thái không thể phủ nhận và sự đáng tin cậy.', '/jɔː vɔɪs ˈkær.iz ˌʌn.dɪˈnaɪ.ə.bəl ˈprɛz.əns ænd kəmˈpɛl.ɪŋ ˌkrɛd.əˈbɪl.ə.ti/'),
        _s('You have conquered Level B2 with exemplary dedication.', 'Bạn đã chinh phục Level B2 với sự nỗ lực mẫu mực.', '/juː hæv ˈkɒŋ.kəd ˈlɛv.əl biː tuː wɪð ɪɡˈzɛm.plər.i ˌdɛd.ɪˈkeɪ.ʃən/'),
        _s('Welcome to the advanced echelons of English mastery!', 'Chào mừng bạn bước vào hàng ngũ làm chủ tiếng Anh cao cấp!', '/ˈwɛl.kəm tuː ðə ədˈvɑːnst ˈɛʃ.ə.lɒnz ɒv ˈɪŋ.ɡlɪʃ ˈmɑː.stər.i/'),
        _s('Keep challenging yourself, greatness awaits at Level C1!', 'Không ngừng thử thách bản thân, đỉnh cao đang chờ đón bạn ở Level C1!', '/kiːp ˈtʃæl.ɪn.dʒɪŋ jɔːˈsɛlf ˈɡreɪt.nəs əˈweɪts æt ˈlɛv.əl siː wʌn/'),
      ]),
    ],
  );

  // ===========================================================================
  // LEVEL C1: ADVANCED (CAO CẤP)
  // ===========================================================================
  static final CourseLevel _levelC1 = CourseLevel(
    code: 'C1',
    title: 'Level C1 - Advanced',
    subtitle: 'Cao cấp & Học thuật',
    description: 'Văn phong học thuật sắc sảo, tranh biện logic sâu rộng, thành ngữ phức hợp và diễn thuyết truyền cảm.',
    primaryColor: const Color(0xFFE65100), // Cam đất quý phái
    secondaryColor: const Color(0xFFFFF3E0),
    icon: Icons.diamond_rounded,
    lessons: [
      _createLesson('C1', 1, 'Học thuật & Tranh biện cao cấp', 'work', Icons.school_rounded, 'Diễn đạt tư tưởng trừu tượng và lập luận sắc bén.', [
        _s('The empirical evidence corroborates the initial hypothesis unequivocally.', 'Các bằng chứng thực nghiệm đã chứng minh giả thuyết ban đầu một cách rõ ràng.', '/ðiː ɪmˈpɪr.ɪ.kəl ˈɛv.ɪ.dəns kəˈrɒb.ə.reɪts ðiː ɪˈnɪʃ.əl haɪˈpɒθ.ə.sɪs ˌʌn.ɪˈkwɪv.ə.kəl.i/'),
        _s('We must critically scrutinize the underlying socio-economic paradigms.', 'Chúng ta phải xem xét kỹ lưỡng các mô hình kinh tế xã hội nền tảng.', '/wiː mʌst ˈkrɪt.ɪ.kəl.i ˈskruː.tɪ.naɪz ðiː ˌʌn.dəˈlaɪ.ɪŋ ˌsəʊ.si.əʊ ˌiː.kəˈnɒm.ɪk ˈpær.ə.daɪmz/'),
        _s('Her cogent critique dismantled the opponent flawed premise effortlessly.', 'Bài phê bình sắc sảo của cô ấy đã bác bỏ tiền đề sai sót của đối thủ một cách dễ dàng.', '/hɜː ˈkəʊ.dʒənt krɪˈtiːk dɪsˈmæn.təld ðiː əˈpəʊ.nənts flɔːd ˈprɛm.ɪs ˈɛf.ət.ləs.li/'),
        _s('Ambiguity in statutory interpretation often leads to contentious litigation.', 'Sự mơ hồ trong cách giải thích luật thường dẫn tới tranh chấp kiện tụng gay gắt.', '/ˌæm.bɪˈɡjuː.ə.ti ɪn ˈstætʃ.ʊ.tər.i ɪnˌtɜː.prɪˈteɪ.ʃən ˈɒf.tən liːdz tuː kənˈtɛn.ʃəs ˌlɪt.ɪˈɡeɪ.ʃən/'),
        _s('Synthesis of disparate theories fosters profound intellectual breakthroughs.', 'Sự tổng hợp các lý thuyết đối lập thúc đẩy những đột phá trí tuệ sâu sắc.', '/ˈsɪn.θə.sɪs ɒv ˈdɪs.pər.ət ˈθɪə.riz ˈfɒs.təz prəˈfaʊnd ˌɪn.təlˈɛk.tʃu.əl ˈbreɪk.θruːz/'),
        _s('Intellectual rigor elevates human understanding to uncharted realms.', 'Sự nghiêm cẩn trong học thuật nâng tầm hiểu biết con người tới những miền đất mới.', '/ˌɪn.təlˈɛk.tʃu.əl ˈrɪɡ.ər ˈɛl.ɪ.veɪts ˈhjuː.mən ˌʌn.dəˈstæn.dɪŋ tuː ʌnˈtʃɑː.tɪd rɛlmz/'),
      ]),
      _createLesson('C1', 2, 'Thành ngữ văn học & Ẩn dụ', 'daily', Icons.auto_stories_rounded, 'Sử dụng thành ngữ đắt giá và biện pháp tu từ tinh xảo.', [
        _s('The revelation threw cold water on their premature jubilation.', 'Sự thật hé lộ đã dội một gáo nước lạnh vào niềm hân hoan quá sớm của họ.', '/ðə ˌrɛv.əˈleɪ.ʃən θruː kəʊld ˈwɔː.tər ɒn ðeər ˌprɛm.əˈtjʊər ˌdʒuː.bɪˈleɪ.ʃən/'),
        _s('He navigated treacherous diplomatic waters with consummate finesse.', 'Ông ấy đã lèo lái qua những vùng nước ngoại giao hiểm trở với sự khéo léo bậc thầy.', '/hiː ˈnæv.ɪ.ɡeɪ.tɪd ˈtrɛtʃ.ər.əs ˌdɪp.ləˈmæt.ɪk ˈwɔː.təz wɪð kənˈsʌm.ət fɪˈnɛs/'),
        _s('Her eloquent speech struck a profound chord within every listener.', 'Bài diễn văn hùng hồn của cô ấy đã chạm tới cung đàn sâu thẳm trong lòng mỗi thính giả.', '/hɜːr ˈɛl.ə.kwənt spiːtʃ strʌk ə prəˈfaʊnd kɔːd wɪðˈɪn ˈɛv.ri ˈlɪs.ən.ər/'),
        _s('To burn bridges in haste is to invite future vulnerability.', 'Vội vã chặt đứt cây cầu sau lưng chính là tự chuốc lấy hiểm nguy trong tương lai.', '/tuː bɜːn ˈbrɪdʒ.ɪz ɪn heɪst ɪz tuː ɪnˈvaɪt ˈfjuː.tʃər ˌvʌl.nər.əˈbɪl.ə.ti/'),
        _s('Patience is the quiet companion of wisdom and true mastery.', 'Kiên nhẫn là người bạn đồng hành thầm lặng của trí tuệ và sự tinh thông đích thực.', '/ˈpeɪ.ʃəns ɪz ðə ˈkwaɪ.ət kəmˈpæn.jən ɒv ˈwɪz.dəm ænd truː ˈmɑː.stər.i/'),
        _s('Subtlety in prose reveals the sublime beauty of articulate minds.', 'Sự tinh tế trong văn chương hé lộ vẻ đẹp cao quý của những tư duy sáng tỏ.', '/ˈsʌt.əl.ti ɪn prəʊz rɪˈviːlz ðə səˈblaɪm ˈbjuː.ti ɒv ɑːˈtɪk.jʊ.lət maɪndz/'),
      ]),
      _createLesson('C1', 3, 'Ngoại giao & Chính sách quốc tế', 'work', Icons.account_balance_rounded, 'Trao đổi về hiệp ước, quan hệ đa phương và lợi ích chiến lược.', [
        _s('Multilateral treaties safeguard peace across fragile geopolitical landscapes.', 'Các hiệp ước đa phương gìn giữ hòa bình giữa những bối cảnh địa chính trị mong manh.', '/ˌmʌl.tiˈlæt.ər.əl ˈtriː.tiz ˈseɪf.ɡɑːd piːs əˈkrɒs ˈfrædʒ.aɪl ˌdʒiː.əʊ.pəˈlɪt.ɪ.kəl ˈlænd.skeɪps/'),
        _s('Diplomatic summits cultivate consensus amidst polarized sovereign interests.', 'Hội nghị thượng đỉnh ngoại giao xây dựng sự đồng thuận giữa những lợi ích đối lập.', '/ˌdɪp.ləˈmæt.ɪk ˈsʌm.ɪts ˈkʌl.tɪ.veɪt kənˈsɛn.səs əˈmɪdst ˈpəʊ.lə.raɪzd ˈsɒv.rɪn ˈɪn.trəsts/'),
        _s('Economic sanctions exert pressure without resorting to armed warfare.', 'Các lệnh trừng phạt kinh tế gây sức ép mà không cần viện tới chiến tranh vũ trang.', '/ˌiː.kəˈnɒm.ɪk ˈsæŋk.ʃənz ɪɡˈzɜːt ˈprɛʃ.ər wɪðˈaʊt rɪˈzɔː.tɪŋ tuː ɑːmd ˈwɔː.feər/'),
        _s('Cultural diplomacy bridges divides that political rhetoric deepens.', 'Ngoại giao văn hóa bắc cầu cho những chia rẽ mà lời lẽ chính trị làm hằn sâu.', '/ˈkʌl.tʃər.əl dɪˈpləʊ.mə.si ˈbrɪdʒ.ɪz dɪˈvaɪdz ðæt pəˈlɪt.ɪ.kəl ˈrɛt.ər.ɪk ˈdiː.pənz/'),
        _s('Sovereignty must balance international humanitarian obligations ethically.', 'Chủ quyền quốc gia cần cân bằng với các nghĩa vụ nhân đạo quốc tế một cách có đạo đức.', '/ˈsɒv.rɪn.ti mʌst ˈbæl.əns ˌɪn.təˈnæʃ.ən.əl hjuːˌmæn.ɪˈteə.ri.ən ˌɒb.lɪˈɡeɪ.ʃənz ˈɛθ.ɪ.kəl.i/'),
        _s('Dialogue remains mankind most dignified instrument of harmony.', 'Đối thoại vẫn là công cụ cao quý nhất của nhân loại để kiến tạo hòa hợp.', '/ˈdaɪ.ə.lɒɡ rɪˈmeɪnz mænˈkaɪnd məʊst ˈdɪɡ.nɪ.faɪd ˈɪn.strʊ.mənt ɒv ˈhɑː.mə.ni/'),
      ]),
      _createLesson('C1', 4, 'Triết học & Nhận thức luận', 'daily', Icons.psychology_rounded, 'Khám phá câu hỏi về ý nghĩa tồn tại và chân lý cuộc sống.', [
        _s('Epistemology investigates the fundamental boundaries of human knowledge.', 'Nhận thức luận nghiên cứu về ranh giới nền tảng của tri thức con người.', '/ɪˌpɪs.tɪˈmɒl.ə.dʒi ɪnˈvɛs.tɪ.ɡeɪts ðə ˌfʌn.dəˈmɛn.təl ˈbaʊn.dər.iz ɒv ˈhjuː.mən ˈnɒl.ɪdʒ/'),
        _s('Existential authenticity demands living in alignment with core convictions.', 'Tính chân thật hiện sinh đòi hỏi ta sống hòa hợp với những niềm tin cốt lõi.', '/ˌɛɡ.zɪˈstɛn.ʃəl ˌɔː.θɛnˈtɪs.ə.ti dɪˈmɑːndz ˈlɪv.ɪŋ ɪn əˈlaɪn.mənt wɪð kɔː kənˈvɪk.ʃənz/'),
        _s('Skepticism when tempered by inquiry prevents ideological dogmatism.', 'Sự hoài nghi khi được tôi luyện bởi tinh thần học hỏi sẽ ngăn chặn chủ nghĩa giáo điều.', '/ˈskɛp.tɪ.sɪ.zəm wɛn ˈtɛm.pəd baɪ ɪnˈkwaɪə.ri prɪˈvɛnts ˌaɪ.di.əˈlɒdʒ.ɪ.kəl ˈdɒɡ.mə.tɪ.zəm/'),
        _s('The pursuit of wisdom transcends material transience.', 'Việc theo đuổi sự thông thái vượt lên trên những phù du vật chất.', '/ðə pəˈsjuːt ɒv ˈwɪz.dəm trænˈsɛndz məˈtɪə.ri.əl ˈtræn.zi.əns/'),
        _s('Reflective contemplation enriches the interior landscape of the soul.', 'Chiêm nghiệm sâu sắc làm phong phú thế giới nội tâm của tâm hồn.', '/rɪˈflɛk.tɪv ˌkɒn.tɛmˈpleɪ.ʃən ɪnˈrɪtʃ.ɪz ðiː ɪnˈtɪə.ri.ər ˈlænd.skeɪp ɒv ðə səʊl/'),
        _s('Self-examination is the inaugural stride toward profound enlightenment.', 'Tự soi xét bản thân là bước khởi đầu hướng tới sự khai sáng sâu sắc.', '/sɛlf ɪɡˌzæm.ɪˈneɪ.ʃən ɪz ðiː ɪˈnɔː.ɡjʊ.rəl straɪd təˈwɔːdz prəˈfaʊnd ɪnˈlaɪ.tən.mənt/'),
      ]),
      _createLesson('C1', 5, 'Chiến lược Doanh nghiệp C-Level', 'work', Icons.domain_rounded, 'Bàn về sáp nhập, tái cấu trúc và định hình tầm nhìn tập đoàn.', [
        _s('The merger unlocked extraordinary synergistic efficiencies across logistics.', 'Vụ sáp nhập đã mở ra những hiệu quả hiệp đồng vượt bậc trong chuỗi cung ứng.', '/ðə ˈmɜː.dʒər ʌnˈlɒkt ɪkˈstrɔː.dɪn.ər.i ˌsɪn.əˈdʒɪs.tɪk ɪˈfɪʃ.ən.siz əˈkrɒs ləˈdʒɪs.tɪks/'),
        _s('Corporate governance must uphold fiduciary duties with absolute integrity.', 'Quản trị công ty phải duy trì trách nhiệm ủy thác với sự liêm chính tuyệt đối.', '/ˈkɔː.pər.ət ˈɡʌv.ən.əns mʌst ʌpˈhəʊld fɪˈdjuː.ʃi.ər.i ˈdjuː.tiz wɪð ˈæb.sə.luːt ɪnˈtɛɡ.rə.ti/'),
        _s('Disruptive market forces require proactive organizational agility.', 'Các biến chuyển thị trường đòi hỏi sự linh hoạt chủ động của cả tổ chức.', '/dɪsˈrʌp.tɪv ˈmɑː.kɪt ˈfɔː.sɪz rɪˈkwaɪə prəʊˈæk.tɪv ˌɔː.ɡən.aɪˈzeɪ.ʃən.əl əˈdʒɪl.ə.ti/'),
        _s('Long-term shareholder value stems from ethical innovation and stewardship.', 'Giá trị cổ đông dài hạn bắt nguồn từ đổi mới có đạo đức và quản trị trách nhiệm.', '/lɒŋ tɜːm ˈʃeəˌhəʊl.dər ˈvæl.juː stɛmz frɒm ˈɛθ.ɪ.kəl ˌɪn.əˈveɪ.ʃən ænd ˈstjuː.əd.ʃɪp/'),
        _s('Venture capital fuels transformative technological paradigm shifts.', 'Vốn đầu tư mạo hiểm tiếp sức cho những chuyển dịch công nghệ mang tính cách mạng.', '/ˈvɛn.tʃə ˈkæp.ɪ.təl fjuːəlz trænsˈfɔː.mə.tɪv ˌtɛk.nəˈlɒdʒ.ɪ.kəl ˈpær.ə.daɪm ʃɪfts/'),
        _s('Excellence in leadership commands respect through visionary execution.', 'Sự xuất sắc trong lãnh đạo tạo dựng sự nể trọng thông qua việc thực thi có tầm nhìn.', '/ˈɛk.səl.əns ɪn ˈliː.də.ʃɪp kəˈmɑːndz rɪˈspɛkt θruː ˈvɪʒ.ən.ər.i ˌɛk.sɪˈkjuː.ʃən/'),
      ]),
      _createLesson('C1', 6, 'Khoa học Sinh học & Đạo đức Y sinh', 'daily', Icons.biotech_rounded, 'Tranh luận về biến đổi gen, trí tuệ nhân tạo y tế và đạo đức sinh học.', [
        _s('Gene editing therapies present unprecedented curative opportunities and bioethical quandaries.', 'Liệu pháp chỉnh sửa gen mang lại cơ hội chữa lành và những băn khoăn đạo đức chưa từng có.', '/dʒiːn ˈɛd.ɪ.tɪŋ ˈθɛr.ə.piz prɪˈzɛnt ʌnˈprɛs.ɪ.dɛn.tɪd ˈkjʊə.rə.tɪv ˌɒp.əˈtjuː.nə.tiz ænd ˌbaɪ.əʊˈɛθ.ɪ.kəl ˈkwɒn.drɪz/'),
        _s('Rigorous clinical trials must substantiate scientific efficacy beyond reasonable skepticism.', 'Thử nghiệm lâm sàng nghiêm ngặt phải chứng minh hiệu quả khoa học vượt trên mọi nghi ngại.', '/ˈrɪɡ.ər.əs ˈklɪn.ɪ.kəl ˈtraɪ.əlz mʌst səbˈstæn.ʃi.eɪt ˌsaɪ.ənˈtɪf.ɪk ˈɛf.ɪ.kə.si bɪˈjɒnd ˈriː.zən.ə.bəl ˈskɛp.tɪ.sɪ.zəm/'),
        _s('Equitable access to groundbreaking medicines remains a pressing humanitarian imperative.', 'Tiếp cận công bằng với thuốc đột phá vẫn là mệnh lệnh nhân đạo cấp bách.', '/ˈɛk.wɪ.tə.bəl ˈæk.sɛs tuː ˈɡraʊndˌbreɪ.kɪŋ ˈmɛd.sɪnz rɪˈmeɪnz ə ˈprɛs.ɪŋ hjuːˌmæn.ɪˈteə.ri.ən ɪmˈpɛr.ə.tɪv/'),
        _s('Medical breakthroughs honor humanity when deployed with unyielding compassion.', 'Đột phá y khoa tôn vinh nhân loại khi được triển khai với lòng trắc ẩn kiên định.', '/ˈmɛd.ɪ.kəl ˈbreɪk.θruːz ˈɒn.ər hjuːˈmæn.ə.ti wɛn dɪˈplɔɪd wɪð ʌnˈjiːl.dɪŋ kəmˈpæʃ.ən/'),
        _s('Safeguard the integrity of therapeutic science against premature commercialization.', 'Bảo vệ tính toàn vẹn của khoa học trị liệu trước sự thương mại hóa nóng vội.', '/ˈseɪf.ɡɑːd ðiː ɪnˈtɛɡ.rə.ti ɒv ˌθɛr.əˈpjuː.tɪk ˈsaɪ.əns əˈɡɛnst ˌprɛm.əˈtjʊə kəˌmɜː.ʃəl.aɪˈzeɪ.ʃən/'),
        _s('Scientific discovery is most radiant when illuminating the path to healing.', 'Khám phá khoa học rực rỡ nhất khi thắp sáng con đường chữa lành nỗi đau.', '/ˌsaɪ.ənˈtɪf.ɪk dɪˈskʌv.ər.i ɪz məʊst ˈreɪ.di.ənt wɛn ɪˈluː.mɪ.neɪ.tɪŋ ðə pɑːθ tuː ˈhiː.lɪŋ/'),
      ]),
      _createLesson('C1', 7, 'Nghệ thuật Hùng biện & Thuyết phục', 'work', Icons.record_voice_over_rounded, 'Khắc họa các thủ pháp hùng biện đỉnh cao như Cicero hay Churchill.', [
        _s('Ethos, pathos, and logos orchestrate the symphony of masterful persuasion.', 'Uy tín, cảm xúc và lý lẽ hòa quyện nên bản giao hưởng của sự thuyết phục bậc thầy.', '/ˈiː.θɒs ˈpeɪ.θɒs ænd ˈlɒɡ.ɒs ˈɔː.kɪ.streɪt ðə ˈsɪm.fə.ni ɒv ˈmɑː.stə.fəl pəˈsweɪ.ʒən/'),
        _s('Modulate tone, cadence, and volume to mesmerize your audience effortlessly.', 'Điều biến ngữ điệu, nhịp điệu và âm lượng để cuốn hút thính giả một cách tự nhiên.', '/ˈmɒdʒ.ʊ.leɪt təʊn ˈkeɪ.dəns ænd ˈvɒl.juːm tuː ˈmɛz.mə.raɪz jɔːr ˈɔː.di.əns ˈɛf.ət.ləs.li/'),
        _s('A well-timed dramatic pause carries more weight than hurried rhetoric.', 'Một khoảng lặng kịch tính đúng lúc có sức nặng hơn ngàn lời tu từ vội vã.', '/ə wɛl taɪmd drəˈmæt.ɪk pɔːz ˈkær.iz mɔː weɪt ðæn ˈhʌr.id ˈrɛt.ər.ɪk/'),
        _s('Articulate speech dissolves hesitation and commands immediate reverence.', 'Lời nói khúc chiết xóa tan sự ngập ngừng và tạo nên sự kính phục tức thì.', '/ɑːˈtɪk.jʊ.lət spiːtʃ dɪˈzɒlvz ˌhɛz.ɪˈteɪ.ʃən ænd kəˈmɑːndz ɪˈmiː.di.ət ˈrɛv.ər.əns/'),
        _s('True eloquence is neither ostentatious nor obscure, but luminously clear.', 'Sự hùng biện đích thực không phô trương hay khó hiểu, mà sáng tỏ một cách rạng rỡ.', '/truː ˈɛl.ə.kwəns ɪz ˈnaɪ.ðər ˌɒs.tɛnˈteɪ.ʃəs nɔːr əbˈskjʊə bʌt ˈluː.mɪ.nəs.li klɪər/'),
        _s('Your voice is an instrument capable of shifting hearts and nations.', 'Giọng nói của bạn là nhạc cụ có thể lay động trái tim và xoay chuyển các quốc gia.', '/jɔː vɔɪs ɪz ən ˈɪn.strʊ.mənt ˈkeɪ.pə.bəl ɒv ˈʃɪf.tɪŋ hɑːts ænd ˈneɪ.ʃənz/'),
      ]),
      _createLesson('C1', 8, 'Biến đổi Xã hội & Trách nhiệm Dân sự', 'daily', Icons.volunteer_activism_rounded, 'Giao tiếp về công bằng xã hội, giáo dục và phát triển cộng đồng.', [
        _s('Civic engagement fosters resilient grassroots movements for progressive reform.', 'Sự dấn thân dân sự nuôi dưỡng những phong trào cơ sở kiên cường vì cải cách tiến bộ.', '/ˈsɪv.ɪk ɪnˈɡeɪdʒ.mənt ˈfɒs.təz rɪˈzɪl.i.ənt ˈɡrɑːs.ruːts ˈmuːv.mənts fɔː prəˈɡrɛs.ɪv rɪˈfɔːm/'),
        _s('Equitable education dismantles systemic cycles of intergenerational disadvantage.', 'Giáo dục bình đẳng phá vỡ những vòng lặp cố hữu của bất lợi qua nhiều thế hệ.', '/ˈɛk.wɪ.tə.bəl ˌɛdʒ.ʊˈkeɪ.ʃən dɪsˈmæn.təlz sɪˈstɛm.ɪk ˈsaɪ.kəlz ɒv ˌɪn.təˌdʒɛn.əˈreɪ.ʃən.əl ˌdɪs.ədˈvɑːn.tɪdʒ/'),
        _s('Inclusivity transforms institutional diversity from buzzwords into dynamic reality.', 'Sự hòa nhập biến tính đa dạng từ khẩu hiệu thành hiện thực sống động.', '/ˌɪn.kluːˈsɪv.ə.ti trænsˈfɔːmz ˌɪn.stɪˈtjuː.ʃən.əl daɪˈvɜː.sɪ.ti frɒm ˈbʌz.wɜːdz ˈɪn.tuː daɪˈnæm.ɪk riˈæl.ə.ti/'),
        _s('Community solidarity proves invincible against environmental and economic shocks.', 'Sự đoàn kết cộng đồng chứng minh sức mạnh bất khả chiến bại trước biến cố.', '/kəˈmjuː.nə.ti ˌsɒl.ɪˈdær.ə.ti pruːvz ɪnˈvɪn.sə.bəl əˈɡɛnst ɪnˌvaɪ.rənˈmɛn.təl ænd ˌiː.kəˈnɒm.ɪk ʃɒks/'),
        _s('Empowering marginalized voices is the hallmark of genuine democracy.', 'Trao quyền cho các tiếng nói yếu thế là dấu ấn của nền dân chủ đích thực.', '/ɪmˈpaʊ.ər.ɪŋ ˈmɑː.dʒɪ.nəl.aɪzd ˈvɔɪ.sɪz ɪz ðə ˈhɔːl.mɑːk ɒv ˈdʒɛn.ju.ɪn dɪˈmɒk.rə.si/'),
        _s('Every small act of justice ripples into waves of lasting transformation.', 'Mỗi hành động công lý nhỏ bé đều tạo nên những làn sóng chuyển hóa trường tồn.', '/ˈɛv.ri smɔːl ækt ɒv ˈdʒʌs.tɪs ˈrɪp.əlz ˈɪn.tuː weɪvz ɒv ˈlɑː.stɪŋ ˌtræns.fəˈmeɪ.ʃən/'),
      ]),
      _createLesson('C1', 9, 'Tương lai loài người & Vũ trụ học', 'daily', Icons.rocket_launch_rounded, 'Khám phá thám hiểm không gian, sự sống ngoài hành tinh và tương lai.', [
        _s('Interplanetary colonization demands groundbreaking feats of propulsion physics.', 'Việc định cư liên hành tinh đòi hỏi những kỳ tích vật lý lực đẩy mang tính cách mạng.', '/ˌɪn.təˈplæn.ɪ.tər.i ˌkɒl.ə.naɪˈzeɪ.ʃən dɪˈmɑːndz ˈɡraʊndˌbreɪ.kɪŋ fiːts ɒv prəˈpʌl.ʃən ˈfɪz.ɪks/'),
        _s('The cosmos invites humanity to ponder our fragile cosmic insignificance.', 'Vũ trụ bao la mời gọi nhân loại suy ngẫm về sự nhỏ bé mong manh của mình.', '/ðə ˈkɒz.mɒs ɪnˈvaɪts hjuːˈmæn.ə.ti tuː ˈpɒn.dər ˈaʊə ˈfrædʒ.aɪl ˈkɒz.mɪk ˌɪn.sɪɡˈnɪf.ɪ.kəns/'),
        _s('Astrophysics bridges ancient mythology and mathematical empirical reality.', 'Vật lý thiên văn nối liền thần thoại cổ xưa với hiện thực toán học thực nghiệm.', '/ˌæs.trəʊˈfɪz.ɪks ˈbrɪdʒ.ɪz ˈeɪn.ʃənt mɪˈθɒl.ə.dʒi ænd ˌmæθ.əˈmæt.ɪ.kəl ɪmˈpɪr.ɪ.kəl riˈæl.ə.ti/'),
        _s('We are made of stardust, seeking to comprehend the universe that birthed us.', 'Chúng ta được tạo nên từ bụi sao, luôn khát khao thấu hiểu vũ trụ đã sinh ra mình.', '/wiː ɑː meɪd ɒv ˈstɑː.dʌst ˈsiː.kɪŋ tuː ˌkɒm.prɪˈhɛnd ðə ˈjuː.nɪ.vɜːs ðæt bɜːθt ʌs/'),
        _s('Humanity curiosity is the inextinguishable flame that defies cosmic void.', 'Sự tò mò của con người là ngọn lửa bất diệt thách thức khoảng không vũ trụ.', '/hjuːˈmæn.ə.ti ˌkjʊə.riˈɒs.ə.ti ɪz ðiː ɪn.ɪkˈstɪŋ.ɡwɪ.ʃə.bəl fleɪm ðæt dɪˈfaɪz ˈkɒz.mɪk vɔɪd/'),
        _s('Dare to look upward, where our grandest destinies patiently wait.', 'Hãy dám ngước nhìn lên cao, nơi những định mệnh huy hoàng nhất đang chờ đợi.', '/deər tuː lʊk ˈʌp.wəd weər ˈaʊə ˈɡræn.dɪst ˈdɛs.tɪ.niz ˈpeɪ.ʃənt.li weɪt/'),
      ]),
      _createLesson('C1', 10, 'Hoàn thành Khóa học C1 xuất sắc', 'daily', Icons.emoji_events_rounded, 'Khẳng định vị thế người dùng tiếng Anh cao cấp.', [
        _s('Your command of nuanced English has reached an enviable level of excellence.', 'Khả năng làm chủ tiếng Anh tinh tế của bạn đã đạt đến đẳng cấp xuất sắc đáng ngưỡng mộ.', '/jɔː kəˈmɑːnd ɒv ˈnjuː.ɑːnst ˈɪŋ.ɡlɪʃ hæz riːtʃt ən ˈɛn.vi.ə.bəl ˈlɛv.əl ɒv ˈɛk.səl.əns/'),
        _s('You effortlessly articulate thoughts with depth, elegance, and natural precision.', 'Bạn diễn đạt tư tưởng với chiều sâu, sự thanh lịch và độ chuẩn xác tự nhiên không tì vết.', '/juː ˈɛf.ət.ləs.li ɑːˈtɪk.jʊ.leɪt θɔːts wɪð dɛpθ ˈɛl.ɪ.ɡəns ænd ˈnætʃ.ər.əl prɪˈsɪʒ.ən/'),
        _s('Advanced fluency is not an endpoint, but a passport to boundless wisdom.', 'Sự lưu loát cao cấp không phải là đích đến, mà là tấm hộ chiếu dẫn vào tri thức vô tận.', '/ədˈvɑːnst ˈfluː.ən.si ɪz nɒt ən ˈɛndˌpɔɪnt bʌt ə ˈpɑːs.pɔːt tuː ˈbaʊnd.ləs ˈwɪz.dəm/'),
        _s('Heartfelt congratulations on mastering Level C1 with supreme distinction!', 'Nhiệt liệt chúc mừng bạn đã làm chủ Level C1 với thành tích xuất sắc phi thường!', '/ˈhɑːt.fɛlt kənˌɡrætʃ.ʊˈleɪ.ʃənz ɒn ˈmɑː.stər.ɪŋ ˈlɛv.əl siː wʌn wɪð suːˈpriːm dɪˈstɪŋk.ʃən/'),
        _s('Level C2 beckons, the final summit of language mastery!', 'Level C2 đang vẫy gọi, đỉnh núi cuối cùng của sự tinh thông ngôn ngữ!', '/ˈlɛv.əl siː tuː ˈbɛk.ənz ðə ˈfaɪ.nəl ˈsʌm.ɪt ɒv ˈlæŋ.ɡwɪdʒ ˈmɑː.stər.i/'),
        _s('Walk with pride, you speak English as a truly sophisticated communicator.', 'Hãy bước đi đầy tự hào, bạn đang nói tiếng Anh như một nhà giao tiếp thực thụ.', '/wɔːk wɪð praɪd juː spiːk ˈɪŋ.ɡlɪʃ æz ə ˈtruː.li səˈfɪs.tɪ.keɪ.tɪd kəˈmjuː.nɪ.keɪ.tər/'),
      ]),
    ],
  );

  // ===========================================================================
  // LEVEL C2: PROFICIENT (THÀNH THẠO NHƯ NGƯỜI BẢN XỨ)
  // ===========================================================================
  static final CourseLevel _levelC2 = CourseLevel(
    code: 'C2',
    title: 'Level C2 - Proficient',
    subtitle: 'Thành thạo như Người Bản Xứ',
    description: 'Đỉnh cao ngôn ngữ, làm chủ mọi sắc thái ngữ điệu, phản xạ tức thời và văn phong bậc thầy.',
    primaryColor: const Color(0xFFC2185B), // Đỏ thẫm quyền lực
    secondaryColor: const Color(0xFFFCE4EC),
    icon: Icons.workspace_premium_rounded,
    lessons: [
      _createLesson('C2', 1, 'Ngữ điệu Thâm sâu & Châm biếm Tinh tế', 'daily', Icons.theater_comedy_rounded, 'Sử dụng ngữ điệu tinh tế để truyền tải ẩn ý và châm biếm nhẹ nhàng.', [
        _s('How delightfully unexpected, whispered the diplomat with an imperceptible smirk.', 'Thật bất ngờ một cách thú vị, nhà ngoại giao thì thầm với nụ cười kín đáo.', '/haʊ dɪˈlaɪt.fəl.i ˌʌn.ɪkˈspɛk.tɪd ˈwɪs.pəd ðə ˈdɪp.lə.mæt wɪð ən ˌɪm.pəˈsɛp.tɪ.bəl smɜːk/'),
        _s('His ostensibly modest facade concealed a labyrinth of ruthlessly calculated ambition.', 'Vẻ ngoài khiêm tốn của ông ta che giấu một ma trận tham vọng được tính toán tàn nhẫn.', '/hɪz ɒsˈtɛn.sɪ.bli ˈmɒd.ɪst fəˈsɑːd kənˈsiːld ə ˈlæb.ə.rɪnθ ɒv ˈruːθ.ləs.li ˈkæl.kjʊ.leɪ.tɪd æmˈbɪʃ.ən/'),
        _s('Irony flourished where bureaucratic absurdity intersected with stubborn pride.', 'Sự mỉa mai nảy nở nơi mà sự ngớ ngẩn quan liêu giao thoa với thói kiêu ngạo bảo thủ.', '/ˈaɪ.rə.ni ˈflʌr.ɪʃt weə ˌbjʊə.rəʊˈkræt.ɪk əbˈsɜː.də.ti ˌɪn.təˈsɛk.tɪd wɪð ˈstʌb.ən praɪd/'),
        _s('She delivered the devastating critique with devastating calm and impeccable poise.', 'Cô ấy đưa ra lời chỉ trích đanh thép với sự điềm tĩnh và phong thái hoàn hảo.', '/ʃiː dɪˈlɪv.əd ðə ˈdɛv.ə.steɪ.tɪŋ krɪˈtiːk wɪð ˈdɛv.ə.steɪ.tɪŋ kɑːm ænd ɪmˈpɛk.ə.bəl pwɑːz/'),
        _s('Mastery of tone permits silence to roar louder than tumultuous proclamation.', 'Làm chủ ngữ điệu cho phép sự im lặng vang dội hơn bất kỳ lời tuyên bố ồn ào nào.', '/ˈmɑː.stər.i ɒv təʊn pəˈmɪts ˈsaɪ.ləns tuː rɔː ˈlaʊ.dər ðæn tjuːˈmʌl.tʃu.əs ˌprɒk.ləˈmeɪ.ʃən/'),
        _s('Wit is the rapier of intellect, wielded best with understated elegance.', 'Sự hóm hỉnh là thanh kiếm của trí tuệ, được vung lên đẹp nhất với sự thanh lịch khiêm nhường.', '/wɪt ɪz ðə ˈreɪ.pi.ər ɒv ˈɪn.təl.ɛkt ˈwiːl.dɪd bɛst wɪð ˌʌn.dəˈsteɪ.tɪd ˈɛl.ɪ.ɡəns/'),
      ]),
      _createLesson('C2', 2, 'Văn phong Bác học & Khảo cứu', 'work', Icons.history_edu_rounded, 'Ngôn ngữ khảo cứu chuẩn mực, trau chuốt và uyên bác.', [
        _s('The archival manuscripts shed illuminating light upon renaissance hermeneutics.', 'Các bản thảo lưu trữ đã soi sáng sâu sắc cho ngành chú giải học thời Phục Hưng.', '/ðiː ɑːˈkaɪ.vəl ˈmæn.jʊ.skrɪpts ʃɛd ɪˈluː.mɪ.neɪ.tɪŋ laɪt əˈpɒn rɪˈneɪ.səns ˌhɜː.mɪˈnjuː.tɪks/'),
        _s('A thorough ontological reassessment recalibrates contemporary philosophy.', 'Một sự đánh giá lại toàn diện về bản thể học sẽ tái định hình triết học đương đại.', '/ə ˈθʌr.ə ˌɒn.təˈlɒdʒ.ɪ.kəl ˌriː.əˈsɛs.mənt ˌriːˈkæl.ɪ.breɪts kənˈtɛm.pər.ər.i fɪˈlɒs.ə.fi/'),
        _s('Erudition without humility devolves into pedantic irrelevance.', 'Sự uyên bác mà thiếu vắng đức khiêm nhường sẽ suy thoái thành sự giáo điều vô nghĩa.', '/ˌɛr.ʊˈdɪʃ.ən wɪðˈaʊt hjuːˈmɪl.ə.ti dɪˈvɒlvz ˈɪn.tuː pɪˈdæn.tɪk ɪˈrɛl.ə.vəns/'),
        _s('Linguistic nuance encapsulates the kaleidoscopic spectrum of human consciousness.', 'Sắc thái ngôn ngữ bao trùm toàn bộ phổ quang đa sắc của ý thức nhân loại.', '/lɪŋˈɡwɪs.tɪk ˈnjuː.ɑːns ɪnˈkæp.sjʊ.leɪts ðə kəˌlaɪ.dəˈskɒp.ɪk ˈspɛk.trəm ɒv ˈhjuː.mən ˈkɒn.ʃəs.nəs/'),
        _s('Scholarly dedication immortalizes fleeting epiphanies into enduring wisdom.', 'Sự tận hiến học thuật lưu giữ những khoảnh khắc giác ngộ thoáng qua thành trí tuệ vĩnh hằng.', '/ˈskɒl.əl.i ˌdɛd.ɪˈkeɪ.ʃən ɪˈmɔː.təl.aɪ.zɪz ˈfliː.tɪŋ ɪˈpɪf.ə.niz ˈɪn.tuː ɪnˈdjʊə.rɪŋ ˈwɪz.dəm/'),
        _s('Knowledge ripens through relentless contemplation and tireless inquiry.', 'Tri thức chỉ chín muồi qua sự chiêm nghiệm không ngừng và tinh thần tìm tòi không mỏi mệt.', '/ˈnɒl.ɪdʒ ˈraɪ.pənz θruː ˈrɪnt.ləs ˌkɒn.tɛmˈpleɪ.ʃən ænd ˈtaɪə.ləs ɪnˈkwaɪə.ri/'),
      ]),
      _createLesson('C2', 3, 'Hùng biện Bậc thầy & Diễn thuyết Triệu người', 'work', Icons.emoji_events_rounded, 'Diễn thuyết truyền cảm hứng lay động triệu trái tim.', [
        _s('We stand at the precipice of destiny, where courage alone commands history.', 'Chúng ta đang đứng trước bờ vực của định mệnh, nơi chỉ có lòng quả cảm mới định đoạt lịch sử.', '/wiː stænd æt ðə ˈprɛs.ɪ.pɪs ɒv ˈdɛs.tɪ.ni weə ˈkʌr.ɪdʒ əˈləʊn kəˈmɑːndz ˈhɪs.tər.i/'),
        _s('Let our legacy be carved in deeds of boundless compassion and fearless vision.', 'Hãy để di sản của chúng ta được khắc ghi bằng lòng trắc ẩn vô bờ và tầm nhìn không sợ hãi.', '/lɛt ˈaʊə ˈlɛɡ.ə.si biː kɑːvd ɪn diːdz ɒv ˈbaʊnd.ləs kəmˈpæʃ.ən ænd ˈfɪə.ləs ˈvɪʒ.ən/'),
        _s('Darkness recedes whenever unshakeable resolve illuminates the human spirit.', 'Bóng tối sẽ lùi xa mỗi khi ý chí sắt đá thắp sáng tâm hồn con người.', '/ˈdɑːk.nəs rɪˈsiːdz wɛnˈɛv.ər ʌnˈʃeɪ.kə.bəl rɪˈzɒlv ɪˈluː.mɪ.neɪts ðə ˈhjuː.mən ˈspɪr.ɪt/'),
        _s('Words are living fire when ignited by the truth of selfless sacrifice.', 'Ngôn từ sẽ là ngọn lửa sống khi được thổi bùng bởi sự hy sinh vị tha.', '/wɜːdz ɑː ˈlɪv.ɪŋ ˈfaɪər wɛn ɪɡˈnaɪ.tɪd baɪ ðə truːθ ɒv ˈsɛlf.ləs ˈsæk.rɪ.faɪs/'),
        _s('Rise, overcome, and transcend every barrier erected by fearful doubt.', 'Hãy vươn lên, vượt qua và chiến thắng mọi rào cản dựng lên bởi nỗi sợ hãi hoài nghi.', '/raɪz ˌəʊ.vəˈkʌm ænd trænˈsɛnd ˈɛv.ri ˈbær.i.ər ɪˈrɛk.tɪd baɪ ˈfɪə.fəl daʊt/'),
        _s('Our journey echoes through eternity when we dare to dream beyond stars.', 'Hành trình của ta sẽ vang vọng muôn đời khi ta dám ước mơ vượt ra ngoài những vì sao.', '/ˈaʊə ˈdʒɜː.ni ˈɛk.əʊz θruː ɪˈtɜː.nə.ti wɛn wiː deər tuː driːm bɪˈjɒnd stɑːz/'),
      ]),
      _createLesson('C2', 4, 'Tác phẩm Văn xuôi Nghệ thuật', 'daily', Icons.menu_book_rounded, 'Câu văn đậm chất thi ca, giàu hình tượng và xúc cảm.', [
        _s('Autumn leaves drifted like whispered reminiscences upon the glassy stream.', 'Những chiếc lá thu trôi bồng bềnh như ký ức thì thầm trên dòng suối trong vắt như gương.', '/ˈɔː.təm liːvz ˈdrɪf.tɪd laɪk ˈwɪs.pəd ˌrɛm.ɪˈnɪs.əns.ɪz əˈpɒn ðə ˈɡlɑː.si striːm/'),
        _s('Twilight draped violet shadows across the ancient cobblestone promenades.', 'Hoàng hôn buông rèm bóng tím huyền ảo trên những con đường lát đá cổ kính.', '/ˈtwaɪ.laɪt dreɪpt ˈvaɪə.lət ˈʃæd.əʊz əˈkrɒs ðiː ˈeɪn.ʃənt ˈkɒb.əl.stəʊn ˌprɒm.əˈnɑːdz/'),
        _s('Solitude welcomed the contemplative wanderer with quiet, tender embrace.', 'Sự cô độc đón chào kẻ lữ hành chiêm nghiệm bằng cái ôm êm dịu và dịu dàng.', '/ˈsɒl.ɪ.tʃuːd ˈwɛl.kəmd ðə kənˈtɛm.plə.tɪv ˈwɒn.dər.ər wɪð ˈkwaɪ.ət ˈtɛn.dər ɪmˈbreɪs/'),
        _s('Echoes of forgotten melodies lingered within the moonlit cathedral.', 'Dư âm của những giai điệu bị lãng quên còn vương vấn trong thánh đường ngập tràn ánh trăng.', '/ˈɛk.əʊz ɒv fəˈɡɒt.ən ˈmɛl.ə.diz ˈlɪŋ.ɡəd wɪðˈɪn ðə ˈmuːn.lɪt kəˈθiː.drəl/'),
        _s('Beauty endures not in permanence, but in the bittersweet ecstasy of passing moments.', 'Vẻ đẹp trường tồn không nằm ở sự bất biến, mà ở niềm say đắm ngọt ngào của khoảnh khắc lướt qua.', '/ˈbjuː.ti ɪnˈdjʊəz nɒt ɪn ˈpɜː.mə.nəns bʌt ɪn ðə ˌbɪt.əˈswiːt ˈɛk.stə.si ɒv ˈpɑːs.ɪŋ ˈməʊ.mənts/'),
        _s('Language touches the divine when it renders the invisible intimately visible.', 'Ngôn từ chạm tới sự thiêng liêng khi nó làm cho những điều vô hình hiện ra thân thuộc.', '/ˈlæŋ.ɡwɪdʒ ˈtʌtʃ.ɪz ðə dɪˈvaɪn wɛn ɪt ˈrɛn.dəz ðiː ɪnˈvɪz.ə.bəl ˈɪn.tɪ.mət.li ˈvɪz.ə.bəl/'),
      ]),
      _createLesson('C2', 5, 'Chiến lược Kiến tạo Tương lai', 'work', Icons.hub_rounded, 'Tầm nhìn tương lai, siêu hệ thống và quản trị phức hợp.', [
        _s('Synthesizing bio-digital technologies redefines the architecture of civilization.', 'Việc tổng hợp công nghệ kỹ thuật số sinh học tái định nghĩa kiến trúc nền văn minh.', '/ˈsɪn.θə.saɪ.zɪŋ ˈbaɪ.əʊ ˈdɪdʒ.ɪ.təl tɛkˈnɒl.ə.dʒiz ˌriː.dɪˈfaɪnz ðiː ˈɑː.kɪ.tɛk.tʃər ɒv ˌsɪv.əl.aɪˈzeɪ.ʃən/'),
        _s('Macro-level systemic governance safeguards equilibrium against catastrophic risks.', 'Quản trị hệ thống vĩ mô bảo đảm trạng thái cân bằng trước các thảm họa khôn lường.', '/ˈmæk.rəʊ ˈlɛv.əl sɪˈstɛm.ɪk ˈɡʌv.ən.əns ˈseɪf.ɡɑːdz ˌiː.kwɪˈlɪb.ri.əm əˈɡɛnst ˌkæt.əˈstrɒf.ɪk rɪsks/'),
        _s('Human potential unfurls exponentially when nurtured in liberated creative environments.', 'Tiềm năng con người bung nở theo cấp số nhân khi được nuôi dưỡng trong môi trường sáng tạo tự do.', '/ˈhjuː.mən pəˈtɛn.ʃəl ʌnˈfɜːlz ˌɛk.spəˈnɛn.ʃəl.i wɛn ˈnɜː.tʃəd ɪn ˈlɪb.ər.eɪ.tɪd kriˈeɪ.tɪv ɪnˈvaɪ.rən.mənts/'),
        _s('Intergenerational stewardship honors descendants through conscientious resource conservation.', 'Trách nhiệm ủy thác xuyên thế hệ tôn vinh con cháu qua việc bảo tồn tài nguyên chu đáo.', '/ˌɪn.təˌdʒɛn.əˈreɪ.ʃən.əl ˈstjuː.əd.ʃɪp ˈɒn.əz dɪˈsɛn.dənts θruː ˌkɒn.ʃiˈɛn.ʃəs rɪˈzɔːs ˌkɒn.səˈveɪ.ʃən/'),
        _s('Wisdom is foresight anchored in profound reverence for shared human destiny.', 'Trí tuệ là tầm nhìn xa được neo giữ trong sự tôn kính sâu sắc đối với số phận chung của nhân loại.', '/ˈwɪz.dəm ɪz ˈfɔː.saɪt ˈæŋ.kəd ɪn prəˈfaʊnd ˈrɛv.ər.əns fɔː ʃeəd ˈhjuː.mən ˈdɛs.tɪ.ni/'),
        _s('Architect tomorrow with uncompromised courage and benevolent wisdom.', 'Hãy kiến tạo ngày mai bằng lòng dũng cảm bất diệt và trí tuệ nhân từ.', '/ˈɑː.kɪ.tɛkt təˈmɒr.əʊ wɪð ʌnˈkɒm.prə.maɪzd ˈkʌr.ɪdʒ ænd bɪˈnɛv.əl.ənt ˈwɪz.dəm/'),
      ]),
      _createLesson('C2', 6, 'Tuyệt kỹ Phát âm Bản xứ C2', 'daily', Icons.all_inclusive_rounded, 'Hòa quyện hoàn hảo: Ngữ điệu, âm nuốt, âm lướt, tốc độ và cảm xúc đỉnh cao.', [
        _s('You have achieved the pinnacle of English phonetics and expressive eloquence.', 'Bạn đã chạm tới đỉnh cao của ngữ âm tiếng Anh và nghệ thuật biểu cảm tuyệt mỹ.', '/juː hæv əˈtʃiːvd ðə ˈpɪn.ə.kəl ɒv ˈɪŋ.ɡlɪʃ fəˈnɛt.ɪks ænd ɪkˈsprɛs.ɪv ˈɛl.ə.kwəns/'),
        _s('Your speech resonates with native naturalness, confidence, and authoritative charm.', 'Lời nói của bạn ngân vang với sự tự nhiên bản xứ, tự tin và sức hút quyền uy.', '/jɔː spiːtʃ ˈrɛz.ən.eɪts wɪð ˈneɪ.tɪv ˈnætʃ.ər.əl.nəs ˈkɒn.fɪ.dəns ænd ɔːˈθɒr.ɪ.tə.tɪv tʃɑːm/'),
        _s('Language is no longer a tool you employ, but an exquisite extension of your thoughts.', 'Ngôn ngữ giờ đây không còn là công cụ bạn sử dụng, mà đã trở thành phần mở rộng tinh tế của suy nghĩ.', '/ˈlæŋ.ɡwɪdʒ ɪz nəʊ ˈlɒŋ.ɡər ə tuːl juː ɪmˈplɔɪ bʌt ən ˈɛk.skwɪ.zɪt ɪkˈstɛn.ʃən ɒv jɔː θɔːts/'),
        _s('Unbounded opportunities across the globe now belong within your grasp.', 'Những cơ hội vô hạn trên toàn cầu giờ đây hoàn toàn nằm trong tầm tay bạn.', '/ʌnˈbaʊn.dɪd ˌɒp.əˈtjuː.nə.tiz əˈkrɒs ðə ɡləʊb naʊ bɪˈlɒŋ wɪðˈɪn jɔː ɡrɑːsp/'),
        _s('Stand tall as an exceptional, world-class English communicator.', 'Hãy ngẩng cao đầu như một nhà giao tiếp tiếng Anh đẳng cấp thế giới xuất chúng.', '/stænd tɔːl æz ən ɪkˈsɛp.ʃən.əl wɜːld klɑːs ˈɪŋ.ɡlɪʃ kəˈmjuː.nɪ.keɪ.tər/'),
        _s('Congratulations, you are officially a Master of English Communication!', 'Chúc mừng bạn, bạn đã chính thức trở thành Bậc Thầy Giao Tiếp Tiếng Anh!', '/kənˌɡrætʃ.ʊˈleɪ.ʃənz juː ɑːr əˈfɪʃ.əl.i ə ˈmɑː.stər ɒv ˈɪŋ.ɡlɪʃ kəˌmjuː.nɪˈkeɪ.ʃən/'),
      ]),
      _createLesson('C2', 7, 'Nghệ thuật Viết Diễn văn Khởi sắc', 'work', Icons.edit_note_rounded, 'Câu văn chuẩn mực cho bài phát biểu khai mạc hay đại hội.', [
        _s('Distinguished guests, we convene not to praise past victories, but to inaugurate new horizons.', 'Kính thưa quý vị, chúng ta hội tụ tại đây không chỉ để ngợi ca chiến thắng cũ, mà để khai mở chân trời mới.', '/dɪˈstɪŋ.ɡwɪʃt ɡɛsts wiː kənˈviːn nɒt tuː preɪz pɑːst ˈvɪk.tər.iz bʌt tuː ɪˈnɔː.ɡjʊ.reɪt njuː həˈraɪ.zənz/'),
        _s('Our collective responsibility transcends ephemeral applause and institutional praise.', 'Trách nhiệm tập thể của chúng ta vượt lên trên những tràng pháo tay ngắn ngủi và lời khen ngợi nhất thời.', '/ˈaʊə kəˈlɛk.tɪv rɪˌspɒn.sɪˈbɪl.ə.ti trænˈsɛndz ɪˈfɛm.ər.əl əˈplɔːz ænd ˌɪn.stɪˈtjuː.ʃən.əl preɪz/'),
        _s('Let truth illuminate our path, unclouded by partisan expediency or transient vanity.', 'Hãy để sự thật thắp sáng lối đi, không bị lu mờ bởi toan tính phe phái hay thói hư danh phù du.', '/lɛt truːθ ɪˈluː.mɪ.neɪt ˈaʊə pɑːθ ʌnˈklaʊ.dɪd baɪ ˈpɑː.tɪ.zæn ɪkˈspiː.di.ən.si ɔː ˈtræn.zi.ənt ˈvæn.ə.ti/'),
        _s('In each courageous voice lies the seed of epochal transformation.', 'Trong mỗi tiếng nói dũng cảm đều ẩn chứa hạt mầm của sự chuyển hóa mang tính thời đại.', '/ɪn iːtʃ kəˈreɪ.dʒəs vɔɪs laɪz ðə siːd ɒv ˈɛp.ək.əl ˌtræns.fəˈmeɪ.ʃən/'),
        _s('With profound humility and resolute hope, we embrace the historic mission before us.', 'Với đức khiêm nhường sâu sắc và niềm hy vọng kiên định, ta đón nhận sứ mệnh lịch sử phía trước.', '/wɪð prəˈfaʊnd hjuːˈmɪl.ə.ti ænd ˈrɛz.ə.luːt həʊp wiː ɪmˈbreɪs ðə hɪˈstɒr.ɪk ˈmɪʃ.ən bɪˈfɔːr ʌs/'),
        _s('Together, we shall author a luminous chapter in humanity chronicle.', 'Cùng nhau, chúng ta sẽ viết nên một chương rực rỡ trong biên niên sử của nhân loại.', '/təˈɡɛð.ər wiː ʃæl ˈɔː.θər ə ˈluː.mɪ.nəs ˈtʃæp.tər ɪn hjuːˈmæn.ə.ti ˈkrɒn.ɪ.kəl/'),
      ]),
      _createLesson('C2', 8, 'Tâm lý Chiều sâu & Thao túng Nhận thức', 'daily', Icons.psychology_alt_rounded, 'Bóc tách các thiên kiến nhận thức và truyền thông đại chúng.', [
        _s('Cognitive dissonance induces uncomfortable psychological tension that compels rationalization.', 'Sự bất hòa nhận thức gây ra căng thẳng tâm lý khó chịu, thúc đẩy ta tự biện minh.', '/ˈkɒɡ.nɪ.tɪv ˈdɪs.ə.nəns ɪnˈdjuː.sɪz ʌnˈkʌm.fə.tə.bəl ˌsaɪ.kəˈlɒdʒ.ɪ.kəl ˈtɛn.ʃən ðæt kəmˈpɛlz ˌræʃ.ən.əl.aɪˈzeɪ.ʃən/'),
        _s('Subliminal rhetoric weaponizes latent biases to orchestrate public sentiment.', 'Thuật hùng biện tiềm thức biến những định kiến ngầm thành vũ khí điều khiển cảm xúc công chúng.', '/sʌbˈlɪm.ɪ.nəl ˈrɛt.ər.ɪk ˈwɛp.ən.aɪ.zɪz ˈleɪ.tənt ˈbaɪ.əs.ɪz tuː ˈɔː.kɪ.streɪt ˈpʌb.lɪk ˈsɛn.tɪ.mənt/'),
        _s('Critical awareness remains our strongest bastion against ideological indoctrination.', 'Nhận thức phản biện vẫn là thành trì vững chắc nhất chống lại sự nhồi sọ tư tưởng.', '/ˈkrɪt.ɪ.kəl əˈweə.nəs rɪˈmeɪnz ˈaʊə ˈstrɒŋ.ɡɪst ˈbæs.ti.ən əˈɡɛnst ˌaɪ.di.əˈlɒdʒ.ɪ.kəl ɪnˌdɒk.trɪˈneɪ.ʃən/'),
        _s('Intellectual autonomy thrives when individuals courageously question charismatic dogma.', 'Sự tự chủ trí tuệ nở rộ khi cá nhân dám dũng cảm chất vấn những giáo điều hào nhoáng.', '/ˌɪn.təlˈɛk.tʃu.əl ɔːˈtɒn.ə.mi θraɪvz wɛn ˌɪn.dɪˈvɪdʒ.u.əlz kəˈreɪ.dʒəs.li ˈkwɛs.tʃən ˌkær.ɪzˈmæt.ɪk ˈdɒɡ.mə/'),
        _s('Discernment separates authentic truth from seductive illusion effortlessly.', 'Sự sáng suốt phân biệt sự thật chân chính khỏi ảo tưởng cám dỗ một cách dễ dàng.', '/dɪˈsɜːn.mənt ˈsɛp.ər.eɪts ɔːˈθɛn.tɪk truːθ frɒm sɪˈdʌk.tɪv ɪˈluː.ʒən ˈɛf.ət.ləs.li/'),
        _s('Guard your mental clarity as your most inviolable sanctuary.', 'Hãy giữ gìn sự minh triết của tâm trí như một thánh địa bất khả xâm phạm.', '/ɡɑːd jɔː ˈmɛn.təl ˈklær.ə.ti æz jɔː məʊst ɪnˈvaɪ.ə.lə.bəl ˈsæŋk.tʃʊ.ər.i/'),
      ]),
      _createLesson('C2', 9, 'Triết lý Thời gian & Thuyết Tương đối', 'daily', Icons.hourglass_full_rounded, 'Chiêm nghiệm sâu xa về dòng chảy thời gian và vũ trụ.', [
        _s('Time is not a rigid linear continuum, but a fluid tapestry woven of consciousness.', 'Thời gian không phải là một đường thẳng cứng nhắc, mà là một tấm thảm dệt bằng ý thức.', '/taɪm ɪz nɒt ə ˈrɪdʒ.ɪd ˈlɪn.i.ər kənˈtɪn.ju.əm bʌt ə ˈfluː.ɪd ˈtæp.ɪ.stri ˈwəʊ.vən ɒv ˈkɒn.ʃəs.nəs/'),
        _s('Memory reconstructs the past through the subjective prism of present emotions.', 'Ký ức tái hiện quá khứ qua lăng kính chủ quan của những cảm xúc hiện tại.', '/ˈmɛm.ər.i ˌriː.kənˈstrʌkts ðə pɑːst θruː ðə səbˈdʒɛk.tɪv ˈprɪz.əm ɒv ˈprɛz.ənt ɪˈməʊ.ʃənz/'),
        _s('The ephemeral nature of beauty renders each fleeting moment exquisitely precious.', 'Tính chất phù du của cái đẹp khiến cho mỗi khoảnh khắc trôi qua đều quý giá vô ngần.', '/ðiː ɪˈfɛm.ər.əl ˈneɪ.tʃər ɒv ˈbjuː.ti ˈrɛn.dəz iːtʃ ˈfliː.tɪŋ ˈməʊ.mənt ˈɛk.skwɪ.zɪt.li ˈprɛʃ.əs/'),
        _s('In stillness, we perceive eternity pulsating beneath the mundane surface of life.', 'Trong sự tĩnh lặng, ta cảm nhận sự vĩnh hằng đang đập rộn ghì dưới lớp vỏ bình thường của đời sống.', '/ɪn ˈstɪl.nəs wiː pəˈsiːv ɪˈtɜː.nə.ti ˈpʌl.seɪ.tɪŋ bɪˈniːθ ðə mʌnˈdeɪn ˈsɜː.fɪs ɒv laɪf/'),
        _s('Embrace the unfolding present, for it is where all possibilities converge.', 'Hãy ôm trọn hiện tại đang mở ra, bởi đó là nơi mọi tiềm năng hội tụ.', '/ɪmˈbreɪs ðiː ʌnˈfəʊl.dɪŋ ˈprɛz.ənt fɔːr ɪt ɪz weər ɔːl ˌpɒs.əˈbɪl.ə.tiz kənˈvɜːdʒ/'),
        _s('Live with deliberate reverence for the mystery that envelops our existence.', 'Hãy sống với sự tôn kính trọn vẹn dành cho những bí ẩn bao trùm sự tồn tại của chúng ta.', '/lɪv wɪð dɪˈlɪb.ər.ət ˈrɛv.ər.əns fɔː ðə ˈmɪs.tər.i ðæt ɪnˈvɛl.əps ˈaʊər ɪɡˈzɪs.təns/'),
      ]),
      _createLesson('C2', 10, 'Đại kỳ tích: Hoàn thành Toàn bộ Lộ trình CEFR', 'daily', Icons.celebration_rounded, 'Vinh danh người học hoàn tất trọn vẹn 60 Units từ A1 đến C2.', [
        _s('You have triumphed across all sixty units, conquering every nuance from A1 to C2!', 'Bạn đã toàn thắng qua cả sáu mươi bài học, chinh phục từng sắc thái từ A1 đến C2!', '/juː hæv ˈtraɪ.əmft əˈkrɒs ɔːl ˈsɪks.ti ˈjuː.nɪts ˈkɒŋ.kər.ɪŋ ˈɛv.ri ˈnjuː.ɑːns frɒm eɪ wʌn tuː siː tuː/'),
        _s('Your linguistic journey stands as an inspiring monument to human dedication.', 'Hành trình ngôn ngữ của bạn là một tượng đài truyền cảm hứng về sự tận tụy của con người.', '/jɔː lɪŋˈɡwɪs.tɪk ˈdʒɜː.ni stændz æz ən ɪnˈspaɪə.rɪŋ ˈmɒn.jʊ.mənt tuː ˈhjuː.mən ˌdɛd.ɪˈkeɪ.ʃən/'),
        _s('The English language is now your canvas, and eloquence is your lifelong brush.', 'Tiếng Anh giờ đây là bức tranh của bạn, và sự hùng biện là cây cọ suốt đời của bạn.', '/ðiː ˈɪŋ.ɡlɪʃ ˈlæŋ.ɡwɪdʒ ɪz naʊ jɔː ˈkæn.vəs ænd ˈɛl.ə.kwəns ɪz jɔː ˈlaɪf.lɒŋ brʌʃ/'),
        _s('Go forth and lead, inspire, and illuminate minds across the world.', 'Hãy tiến lên phía trước để dẫn dắt, truyền cảm hứng và thắp sáng những tâm hồn khắp thế gian.', '/ɡəʊ fɔːθ ænd liːd ɪnˈspaɪər ænd ɪˈluː.mɪ.neɪt maɪndz əˈkrɒs ðə wɜːld/'),
        _s('Never cease cultivating the infinite wonders of articulate human expression.', 'Đừng bao giờ ngừng nuôi dưỡng những kỳ quan vô tận của ngôn từ khúc chiết.', '/ˈnɛv.ər siːs ˈkʌl.tɪ.veɪ.tɪŋ ðiː ˈɪn.fɪ.nət ˈwʌn.dəz ɒv ɑːˈtɪk.jʊ.lət ˈhjuː.mən ɪkˈsprɛʃ.ən/'),
        _s('Congratulations, Champion! You are truly a Grandmaster of English!', 'Chúc mừng Đại Quán Quân! Bạn thực sự là một Đại Kiện Tướng Tiếng Anh!', '/kənˌɡrætʃ.ʊˈleɪ.ʃənz ˈtʃæm.pi.ən juː ɑː ˈtruː.li ə ˈɡrændˌmɑː.stər ɒv ˈɪŋ.ɡlɪʃ/'),
      ]),
      _createLesson('C2', 11, 'Thành ngữ & Tục ngữ uyên bác & triết lý', 'idioms', Icons.format_quote_rounded, 'Đỉnh cao ngôn từ với những câu danh ngôn thâm sâu.', [
        _s('Beauty is in the eye of the beholder.', 'Cái đẹp nằm trong con mắt của kẻ si tình.', '/ˈbjuː.ti ɪz ɪn ðiː aɪ ɒv ðə bɪˈhəʊl.dər/'),
        _s('Fortune favors the bold.', 'Thần may mắn luôn mỉm cười với người dũng cảm.', '/ˈfɔː.tʃuːn ˈfeɪ.vərz ðə bəʊld/'),
        _s('Still waters run deep.', 'Nước lặng chảy sâu, người khiêm nhường ắt tài hoa.', '/stɪl ˈwɔː.tərz rʌn diːp/'),
        _s('When in Rome, do as the Romans do.', 'Nhập gia tùy tục.', '/wɛn ɪn rəʊm duː æz ðə ˈrəʊ.mənz duː/'),
        _s('The pen is mightier than the sword.', 'Ngòi bút có sức mạnh vượt xa lưỡi gươm.', '/ðə pɛn ɪz ˈmaɪ.ti.ər ðæn ðə sɔːd/'),
        _s('All that glitters is not gold.', 'Không phải mọi thứ lấp lánh đều là vàng nguyên chất.', '/ɔːl ðæt ˈɡlɪt.ərz ɪz nɒt ɡəʊld/'),
      ]),
    ],
  );

  static CourseLesson _createLesson(
    String levelCode,
    int unitNumber,
    String title,
    String topic,
    IconData icon,
    String description,
    List<StudySentence> sentences,
  ) {
    return CourseLesson(
      id: '${levelCode}_unit_$unitNumber',
      levelCode: levelCode,
      unitNumber: unitNumber,
      title: 'Bài $unitNumber: $title',
      topic: topic,
      icon: icon,
      description: description,
      sentences: sentences,
    );
  }

  static StudySentence _s(String sentence, String meaning, String ipa) {
    return StudySentence(
      topic: 'general',
      sentence: sentence,
      meaning: meaning,
      ipa: ipa,
      timeCreate: DateTime.now(),
    );
  }
}


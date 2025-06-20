// import 'package:flutter/material.dart';

// class AppTextStyles {
//   static const TextStyle heading =
//       TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

//   static const TextStyle buttonTextStyle = TextStyle(
//     fontSize: 20,
//     color: Colors.white,
//   );

//   static const TextStyle krishiHeading = TextStyle(
//     color: Color.fromRGBO(29, 145, 67, 1),
//     fontSize: 36,
//   );
// }

// class AppColors {
//   static const Color appColor = Color.fromRGBO(242, 239, 228, 0.93);
// }


import 'package:flutter/material.dart';

class AppColors {
  static const Color appColor = Color.fromRGBO(242, 239, 228, 0.93);
  static const Color primaryGreen = Color.fromRGBO(85, 107, 47, 1);
  static const Color labelColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color white = Colors.white;
  static const Color red =  Color.fromRGBO(139, 69, 19, 1);
  static const Color primaryGreenDark = Color.fromRGBO(107, 142, 35, 1);
  static const Color lightRedCard = Color.fromRGBO(255, 242, 242, 1);
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.25);

}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle krishiHeading = TextStyle(
    color: Color.fromRGBO(29, 145, 67, 1),
    fontSize: 36,
  );

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.labelColor,
    fontSize: 20,
  );

  static const TextStyle floatingLabelStyle = TextStyle(
    color: AppColors.labelColor,
    fontSize: 20,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bottomText = TextStyle(
    color: AppColors.labelColor,
    fontSize: 18,
  );

  static const TextStyle linkText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle pageHeading = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

static const TextStyle cardTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

static const TextStyle cardSubText = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Color.fromRGBO(0, 0, 0, 0.75),
);

static const TextStyle smallLabel = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 13,
  color: Color.fromRGBO(0, 0, 0, 0.75),
);

static const TextStyle linkStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 13,
  color: Color.fromRGBO(107, 142, 35, 1),
);

static const TextStyle modalTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

static const TextStyle modalLabel = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(0, 0, 0, 0.75),
);

static const TextStyle modalInfoLink = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(48, 1, 255, 0.75),
);

static const TextStyle welcomeHeading = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
);

static const TextStyle noDataText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: AppColors.labelColor,
);

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 20,
    color: AppColors.primaryGreenDark,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle infoTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
}

InputDecoration customInputDecoration(String label, {Widget? suffixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    labelText: label,
    labelStyle: AppTextStyles.labelStyle,
    floatingLabelStyle: AppTextStyles.floatingLabelStyle,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    suffixIcon: suffixIcon,
  );
}


BoxDecoration cardBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: AppColors.lightRedCard,
  boxShadow: const [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 4,
      offset: Offset(0, 4),
    ),
  ],
);

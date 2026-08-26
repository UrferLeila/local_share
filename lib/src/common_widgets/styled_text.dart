import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_share/src/theme/theme.dart';

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.concertOne(
        textStyle: Theme.of(context).textTheme.titleLarge,
        color: AppColors.lightwhite,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}

class StyledSmallTitle extends StatelessWidget {
  const StyledSmallTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.googleSans(
        textStyle: Theme.of(context).textTheme.titleMedium,
        color: AppColors.lightwhite,
      ),
      textAlign: TextAlign.left,
      softWrap: true,
    );
  }
}

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cause(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        color: AppColors.grey,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}

class StyledBase extends StatelessWidget {
  const StyledBase(
    this.text, {
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.cause(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        color: AppColors.lightwhite,
      ),
      textAlign: textAlign,
      softWrap: true,
    );
  }
}

class StyledLink extends StatelessWidget {
  const StyledLink(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cause(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        color: AppColors.cyan,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}

class StyledAppBar extends StatelessWidget {
  const StyledAppBar(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.googleSans(
        textStyle: Theme.of(context).textTheme.titleLarge,
        color: AppColors.lightwhite,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}

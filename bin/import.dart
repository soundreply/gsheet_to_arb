/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

library gsheet_to_arb;

import 'dart:io';

import 'package:args/args.dart';
import 'package:gsheet_to_arb/gsheet_to_arb.dart';
import 'package:gsheet_to_arb/src/arb/arb_serializer.dart';

main(List<String> args) async {
  var parser = new ArgParser();
  var configFilePath = "./.gsheet_to_arb.yaml";

  parser.addOption("config",
      defaultsTo: configFilePath,
      callback: (x) => configFilePath = x,
      help: 'config yaml file name');

  parser.parse(args);
  if (args.length == 0) {
    print('Imports ARB file from exisiting GSheet document');
    print('Usage: gsheet_to_arb [options]');
    print(parser.usage);
    exit(0);
  }

  var config = PluginConfig.fromYamlFile(configFilePath);

  var sheetParser = SheetParser();
  var bundle = await sheetParser.parseSheet(config.sheetConfig);

  var arbSerializer = ArbSerializer();
  arbSerializer.saveArbBundle(bundle, config.outputDirectoryPath);
}

/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#define CATCH_CONFIG_RUNNER

#include <QDir>

#include <catch2/catch.hpp>

// --- Prototypes --- //
void init();
void cleanup();

// --- Main --- //
int main(int argc, char* argv[])
{
    init();
    int catchResult = Catch::Session().run(argc, argv);
    cleanup();
    return catchResult;
}

void init()
{
    Q_INIT_RESOURCE(gm_apps_plugin_cranial_rc);
}

void cleanup()
{
    Q_CLEANUP_RESOURCE(gm_apps_plugin_cranial_rc);
}

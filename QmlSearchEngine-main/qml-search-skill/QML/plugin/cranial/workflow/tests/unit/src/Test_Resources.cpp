/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include <catch2/catch.hpp>

#include <QFile>
#include <QString>

#include <string>

namespace test_resources {

TEST_CASE("cranial::plugin::Resources", "[cranial][backend][Resources]")
{
    std::vector<std::string> fileUrls{":/cranial/qml/cranial.qml",
                                      ":/cranial/qml/components/Calculator.qml",
                                      ":/images/face.svg"};

    for (const auto& fileUrl : fileUrls)
    {
        INFO(fileUrl)

        QFile file(QString::fromStdString(fileUrl));
        REQUIRE(file.open(QIODevice::ReadOnly | QIODevice::Text));
    }
}

}  // namespace test_resources

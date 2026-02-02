/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <QObject>

#ifndef Q_MOC_RUN

#include <memory>

#endif

namespace drive::com::propertysource {
class PatientDetailsPropertySource;
class PatientsPropertySource;
}  // namespace drive::com::propertysource

namespace drive::viewmodel {

/**
 * View model for the selected patient's name display in the drive topbar.
 */
class PatientNameViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString patientName READ patientName NOTIFY patientNameChanged)
    Q_PROPERTY(
        bool patientSelected READ patientSelected NOTIFY patientSelectedChanged)

public:
    explicit PatientNameViewModel(QObject* parent = nullptr);

    /**
     * Get patient name in the following format: [Last name], [First initial] (e.g. "Doe, J.").
     */
    QString patientName() const { return m_patientName; }

    /**
     * Indicates whether a patient is selected.
     */
    bool patientSelected() const { return m_patientSelected; }

signals:
    void patientNameChanged(const QString& patientName);
    void patientSelectedChanged(bool selected);

private slots:
    void onPatientNameChanged(const QString& patientName);
    void onSelectedPatientIdStrChanged(const QString& patientIdStr);

private:
    QString m_patientName{""};
    bool m_patientSelected{false};
    std::unique_ptr<drive::com::propertysource::PatientDetailsPropertySource>
        m_patientDetailsPS;
    std::unique_ptr<drive::com::propertysource::PatientsPropertySource>
        m_patientsPS;
};

}  // namespace drive::viewmodel

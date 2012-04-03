#ifndef NEWSFEEDMODEL_H
#define NEWSFEEDMODEL_H

#include <QAbstractListModel>

class NewsFeedModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit NewsFeedModel(QObject *parent = 0);
    
signals:
    
public slots:
    
};

#endif // NEWSFEEDMODEL_H

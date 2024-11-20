export interface FileEntity {
    uid: string;
    name: string;
    size: number;
    download_url: string;
    path: string;
    owner_uid: string;
    expiration_date: number;
} // TODO: file should have users in reference
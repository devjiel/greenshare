export interface FileEntity {
    uid: string;
    name: string;
    size: number;
    download_url: string;
    path: string;
    owner_uid: string;
    shared_with: string[];
    expiration_date: number;
}